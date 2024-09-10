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
LISTMONK_AUTHORIZATION = os.environ["LISTMONK_AUTHORIZATION"]
PORT = int(os.getenv("PORT", 8000))


def init_metrics():
    global current_subscribers
    current_subscribers = Gauge(
        "listmonk_current_subscribers",
        "Total new subscriptions",
        ["email", "subscription_status"],
    )


def hashify_labels(**labels) -> int:
    return hash(frozenset(labels.items()))


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


def background_task():
    while not shutdown_event.is_set():
        with httpx.Client(
            base_url=LISTMONK_HOST,
            params={
                "list_id": 3,
                "order_by": "created_at",
                "order": "ASC",
                "per_page": "all",
            },
            headers={"authorization": "Basic " + LISTMONK_AUTHORIZATION},
        ) as client:
            json = client.get("/api/subscribers").json()

            for subscriber in json["data"]["results"]:
                subscription_status = subscriber["lists"][0]["subscription_status"]
                labels = {
                    "email": subscriber["email"],
                    "subscription_status": subscription_status,
                }
                value = hashify_labels(**labels)
                current_subscribers.labels(**labels).set(value)

        shutdown_event.wait(60)


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
