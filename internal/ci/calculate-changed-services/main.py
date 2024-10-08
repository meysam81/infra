#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
This file will generate an output similar to the following:

matrix={"directory":["applications/app1","applications/app2"]}
length=2
"""

import argparse
import hashlib
import json
import os
import subprocess
from collections import defaultdict as dd

import redis

parser = argparse.ArgumentParser()

parser.add_argument("--action", default="get", choices=["get", "set"])

output = os.environ["GITHUB_OUTPUT"]
redis_host = os.environ["REDIS_HOST"]
redis_port = int(os.getenv("REDIS_PORT", "6379"))
redis_password = os.environ["REDIS_PASSWORD"]
redis_ssl = os.getenv("REDIS_SSL", "false") == "true"

cache_key = os.getenv("CACHE_KEY", "infra-services")

cache = redis.Redis(
    host=redis_host, port=redis_port, password=redis_password, ssl=redis_ssl
)

root_dir = "applications"

# This could possibly be in the service as well!
platforms = dd(lambda: ["linux/amd64", "linux/arm64"])


def _calculate_service_hash(svc) -> str:
    output = subprocess.check_output(
        ["find", svc, "-type", "f", "-exec", "sha256sum", "{}", ";"],
    )
    return hashlib.sha256(output).hexdigest()


def _get_all_hashes(only_dockerfile=True) -> dict:
    dir_path = root_dir
    services = []
    for f in os.scandir(dir_path):
        if not f.is_dir():
            continue
        if only_dockerfile and not os.path.exists(os.path.join(f.path, "Dockerfile")):
            continue
        services.append(f.path)

    current_hashes = {}

    for svc in services:
        current_hashes[svc] = _calculate_service_hash(svc)

    return current_hashes


def _jsonify(item_lists: list[str]) -> str:
    return json.dumps(item_lists, separators=(",", ":"))


def _get_old_service_hashes() -> dict:
    old_hashes = cache.hgetall(cache_key)
    return {k.decode(): v.decode() for k, v in old_hashes.items()}


def get_hashes():
    old_hashes = _get_old_service_hashes()
    current_hashes = _get_all_hashes()

    print(f"old_hashes={old_hashes}")
    print(f"current_hashes={current_hashes}")

    include = []
    for service, hash in current_hashes.items():
        if old_hashes.get(service) != hash:
            basename = os.path.basename(service)
            include.append(
                {
                    "directory": service,
                    "platforms": ",".join(platforms[service]),
                    "image-name": basename,
                }
            )

    matrix = {"include": include}
    length = len(include)

    print(f"matrix={_jsonify(matrix)}")
    print(f"length={length}")

    with open(output, "a") as f:
        f.write(f"matrix={_jsonify(matrix)}\n")
        f.write(f"length={length}\n")


def set_hashes():
    current_hashes = _get_all_hashes()

    print(current_hashes)

    cache.hset(cache_key, mapping=current_hashes)


if __name__ == "__main__":
    args = parser.parse_args()

    match args.action:
        case "get":
            get_hashes()
        case "set":
            set_hashes()
        case default:
            raise ValueError(f"Unknown action: {args.action}")
