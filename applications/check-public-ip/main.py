# -*- coding: utf-8 -*-
import logging
import time
from collections import OrderedDict

import httpx
from prometheus_client import Gauge, start_http_server


def get_logger(level="INFO"):
    logger = logging.getLogger(__name__)
    logger.setLevel(level)

    handler = logging.StreamHandler()
    handler.setLevel(level)

    formatter = logging.Formatter(
        "[%(levelname)s] %(asctime)s - %(name)s - %(message)s"
    )
    handler.setFormatter(formatter)

    logger.addHandler(handler)

    return logger


class EvictingDict(OrderedDict):
    __slots__ = ("max_size",)

    def __init__(self, max_size, *args, **kwargs):
        self.max_size = max_size
        super().__init__(*args, **kwargs)

    def __getitem__(self, key):
        if len(self) >= self.max_size:
            logger.info(f"Max size {self.max_size} reached, evicting key={key}")
            self.popitem(last=False)
        if not self.get(key):
            logger.info(f"Adding new key={key}, current size={len(self)}")
            current_timestamp = int(time.time())
            self[key] = current_timestamp
        return super().__getitem__(key)


ip_addresses = EvictingDict(32)


public_ip_metric = Gauge("public_ip", "Hash of the Public IP address", ["ip_address"])
logger = get_logger()


def get_public_ip():
    response = httpx.get("https://checkip.amazonaws.com")
    return response.text.strip()


if __name__ == "__main__":
    logger.info("Listening on port 8000 ...")
    start_http_server(8000)

    while True:
        public_ip = get_public_ip()

        public_ip_metric.labels(ip_address=public_ip).set(ip_addresses[public_ip])

        time.sleep(60)
