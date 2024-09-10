#!/usr/bin/env python
# -*- coding: utf-8 -*-
import logging
import os
import threading
from base64 import b64encode

import httpx
from prometheus_client import Gauge, start_http_server

shutdown_event = threading.Event()


current_subscribers = None
LISTMONK_HOST = os.environ["LISTMONK_HOST"]
LISTMONK_AUTHORIZATION = os.getenv("LISTMONK_AUTHORIZATION")
LISTMONK_ADMIN_USERNAME = os.getenv("LISTMONK_ADMIN_USERNAME")
LISTMONK_ADMIN_PASSWORD = os.getenv("LISTMONK_ADMIN_PASSWORD")
PORT = int(os.getenv("PORT", 8000))

# either auth header or the user-pass must be specified
assert (
    LISTMONK_AUTHORIZATION or (LISTMONK_ADMIN_USERNAME and LISTMONK_ADMIN_PASSWORD)
), "Either LISTMONK_AUTHORIZATION or LISTMONK_ADMIN_USERNAME and LISTMONK_ADMIN_PASSWORD must be provided"

if LISTMONK_AUTHORIZATION:
    AUTH_HEADER = LISTMONK_AUTHORIZATION
else:
    AUTH_HEADER = b64encode(
        f"{LISTMONK_ADMIN_USERNAME}:{LISTMONK_ADMIN_PASSWORD}".encode()
    ).decode()


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
            headers={"authorization": "Basic " + AUTH_HEADER},
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
