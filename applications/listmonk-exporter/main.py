#!/usr/bin/env python
# -*- coding: utf-8 -*-
import argparse
import logging
import os
import threading
from collections import defaultdict

import httpx
from prometheus_client import Gauge, start_http_server

shutdown_event = threading.Event()


subscribers_by_status = None
subscribers_total = None


def parse_args():
    parser = argparse.ArgumentParser(
        description="Listmonk Prometheus Exporter",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )

    parser.add_argument(
        "--listmonk-host",
        type=str,
        required=True,
        help="Listmonk host URL (required)",
        default=os.environ.get("LISTMONK_HOST"),
    )

    parser.add_argument(
        "--listmonk-api-user",
        type=str,
        required=True,
        help="Listmonk API username (required)",
        default=os.environ.get("LISTMONK_API_USER"),
    )

    parser.add_argument(
        "--listmonk-api-token",
        type=str,
        required=True,
        help="Listmonk API token (required)",
        default=os.environ.get("LISTMONK_API_TOKEN"),
    )

    parser.add_argument(
        "--list-id",
        type=int,
        required=True,
        help="Listmonk list ID to monitor (required)",
        default=os.environ.get("LIST_ID"),
    )

    parser.add_argument(
        "--list-name",
        type=str,
        required=True,
        default=os.getenv("LIST_NAME"),
        help="Name of the list to monitor",
    )

    parser.add_argument(
        "--scrape-interval",
        type=int,
        default=int(os.getenv("SCRAPE_INTERVAL", "60")),
        help="Scrape interval in seconds",
    )

    parser.add_argument(
        "--port",
        type=int,
        default=int(os.getenv("PORT", "8000")),
        help="Port for Prometheus HTTP server",
    )

    parser.add_argument(
        "--log-level",
        type=str,
        default=os.getenv("LOG_LEVEL", "INFO"),
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
        help="Logging level",
    )

    return parser.parse_args()


def init_metrics():
    global subscribers_by_status, subscribers_total

    subscribers_by_status = Gauge(
        "listmonk_subscribers_by_status",
        "Number of subscribers by subscription status",
        ["list_name", "subscription_status"],
    )

    subscribers_total = Gauge(
        "listmonk_subscribers_total",
        "Total number of subscribers in the list",
        ["list_name"],
    )


def hashify_labels(**labels) -> int:
    return abs(hash(frozenset(labels.items())))


def get_logger(level="INFO"):
    logger = logging.getLogger(__name__)
    logger.setLevel(level)

    handler = logging.StreamHandler()
    handler.setLevel(level)

    formatter = logging.Formatter(
        "[%(levelname)s] %(asctime)s - %(filename)s:%(lineno)d - %(message)s"
    )
    handler.setFormatter(formatter)

    logger.addHandler(handler)

    return logger


def upgrade_metrics(args):
    with httpx.Client(
        base_url=args.listmonk_host,
        params={
            "list_id": args.list_id,
            "order_by": "created_at",
            "order": "ASC",
            "per_page": "all",
        },
        headers={
            "authorization": f"token {args.listmonk_api_user}:{args.listmonk_api_token}",
        },
    ) as client:
        json = client.get("/api/subscribers").json()

        status_counts = defaultdict(int)
        total_count = 0

        for subscriber in json["data"]["results"]:
            list_filter = filter(
                lambda list_: list_["name"] == args.list_name, subscriber["lists"]
            )
            try:
                subscriber_list = next(list_filter)
                subscription_status = subscriber_list["subscription_status"]
                status_counts[subscription_status] += 1
                total_count += 1
            except StopIteration:
                continue

        for status, count in status_counts.items():
            subscribers_by_status.labels(
                list_name=args.list_name, subscription_status=status
            ).set(count)

        subscribers_total.labels(list_name=args.list_name).set(total_count)


def background_task(args, logger):
    while not shutdown_event.is_set():
        try:
            upgrade_metrics(args)
        except Exception as e:
            logger.error(f"Failed to scrape metrics: {e}")

        shutdown_event.wait(args.scrape_interval)


def main():
    args = parse_args()

    logger = get_logger(args.log_level)

    logger.info("Initializing metrics...")
    init_metrics()

    logger.info("Starting background task...")
    background_thread = threading.Thread(
        target=background_task, args=(args, logger), daemon=True
    )
    background_thread.start()

    logger.info("Starting Prometheus HTTP server...")
    _, main_thread = start_http_server(args.port)
    try:
        logger.info(f"Listen on port {args.port}")
        main_thread.join()
    except KeyboardInterrupt:
        logger.warning("Shutting down after receiving SIGINT")
        shutdown_event.set()
        background_thread.join()


if __name__ == "__main__":
    main()
