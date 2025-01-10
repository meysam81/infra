#!/usr/bin/env python
# -*- coding: utf-8 -*-
import logging
import os
import threading

import httpx
from prometheus_client import Gauge, start_http_server

shutdown_event = threading.Event()


current_subscribers = None
LISTMONK_HOST = os.environ["LISTMONK_HOST"]
LISTMONK_API_USER = os.getenv("LISTMONK_API_USER")
LISTMONK_API_TOKEN = os.getenv("LISTMONK_API_TOKEN")
LIST_NAME = os.getenv("LIST_NAME", "Developer Friendly Blog")
SCRAPE_INTERVAL = int(os.getenv("SCRAPE_INTERVAL", 60))
PORT = int(os.getenv("PORT", 8000))


def init_metrics():
    global current_subscribers
    current_subscribers = Gauge(
        "listmonk_current_subscribers",
        "Total new subscriptions",
        ["email", "name", "subscription_status", "subscription_updated_at"],
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


def upgrade_metrics():
    with httpx.Client(
        base_url=LISTMONK_HOST,
        params={
            "list_id": 3,
            "order_by": "created_at",
            "order": "ASC",
            "per_page": "all",
        },
        headers={
            "authorization": f"token {LISTMONK_API_USER}:{LISTMONK_API_TOKEN}",
        },
    ) as client:
        json = client.get("/api/subscribers").json()

        for subscriber in json["data"]["results"]:
            list = filter(lambda list_: list_["name"] == LIST_NAME, subscriber["lists"])
            try:
                subscriber_list = next(list)
            except StopIteration:
                subscriber_list = None
            subscription_status = subscriber_list["subscription_status"]
            subscription_updated_at = subscriber_list["updated_at"]
            labels = {
                "email": subscriber["email"],
                "name": subscriber["name"],
                "subscription_status": subscription_status,
                "subscription_updated_at": subscription_updated_at,
            }
            value = hashify_labels(**labels)
            current_subscribers.labels(**labels).set(value)


def background_task():
    while not shutdown_event.is_set():
        try:
            upgrade_metrics()
        except Exception as e:
            logger.error(f"Failed to scrape metrics: {e}")

        shutdown_event.wait(SCRAPE_INTERVAL)


background_thread = threading.Thread(target=background_task, daemon=True)
logger = get_logger(os.getenv("LOG_LEVEL", "INFO"))

if __name__ == "__main__":
    logger.info("Initializing metrics...")
    init_metrics()

    logger.info("Starting background task...")
    background_thread.start()

    logger.info("Starting Prometheus HTTP server...")
    _, main_thread = start_http_server(PORT)
    try:
        logger.info(f"Listen on port {PORT}")
        main_thread.join()
    except KeyboardInterrupt:
        logger.warn("Shutting down after receiving SIGINT")
        shutdown_event.set()
        background_thread.join()
