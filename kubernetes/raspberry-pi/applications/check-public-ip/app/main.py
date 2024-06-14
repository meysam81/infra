# -*- coding: utf-8 -*-
import time
import httpx
from prometheus_client import start_http_server, Gauge

public_ip_metric = Gauge("public_ip", "Hash of the Public IP address", ["ip_address"])


def get_public_ip():
    response = httpx.get("https://checkip.amazonaws.com")
    return response.text.strip()


if __name__ == "__main__":
    start_http_server(8000)

    while True:
        public_ip = get_public_ip()

        public_ip_metric.labels(ip_address=public_ip).set(1)

        time.sleep(60)
