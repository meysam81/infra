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
LIST_NAME = os.getenv("LIST_NAME", "Developer Friendly Blog")
SCRAPE_INTERVAL = int(os.getenv("SCRAPE_INTERVAL", 60))
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
        headers={"authorization": "Basic " + AUTH_HEADER},
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
