# -*- coding: utf-8 -*-
import httpx
from prometheus_client import start_http_server, Gauge
import time

from collections import OrderedDict


class EvictingDict(OrderedDict):
    __slots__ = ("max_size", "counter")

    def __init__(self, max_size, *args, **kwargs):
        self.max_size = max_size
        self.counter = 0
        super().__init__(*args, **kwargs)

    def __setitem__(self, key, _):
        if len(self) >= self.max_size:
            self.popitem(last=False)
        if not self.get(key):
            self.counter += 1
            super().__setitem__(key, self.counter)


ip_addresses = EvictingDict(32)


public_ip_metric = Gauge("public_ip", "Hash of the Public IP address", ["ip_address"])


def get_public_ip():
    response = httpx.get("https://checkip.amazonaws.com")
    return response.text.strip()


if __name__ == "__main__":
    start_http_server(8000)

    while True:
        public_ip = get_public_ip()

        ip_addresses[public_ip] = None

        public_ip_metric.labels(ip_address=public_ip).set(ip_addresses[public_ip])

        time.sleep(60)
