# -*- coding: utf-8 -*-
import requests
from pymongo import MongoClient
import sendgrid
from sendgrid.helpers.mail import Mail
import os

import argparse

parser = argparse.ArgumentParser()

parser.add_argument(
    "--from-email", type=str, default="no-reply@developer-friendly.blog"
)
parser.add_argument("--to-email", type=str, default="meysam@developer-friendly.blog")
parser.add_argument("--subject", type=str, default="IP Address Mismatch")
parser.add_argument(
    "--plain-text-content",
    type=str,
    default="The public IP address has changed. New IP: {current_ip}",
)

SENDGRID_API_KEY = os.environ["SENDGRID_API_KEY"]
MONGO_URI = os.environ["MONGO_URI"]
MONGO_DB = os.getenv("MONGO_DB", "personal")
MONGO_COLLECTION = os.getenv("MONGO_COLLECTION", "public_ip")
MONGO_TIMEOUT = os.getenv("MONGO_TIMEOUT", 5000)


def get_public_ip():
    response = requests.get("https://checkip.amazonaws.com")
    return response.text


def get_mongo():
    client = MongoClient(MONGO_URI, serverSelectionTimeoutMS=MONGO_TIMEOUT)
    db = client[MONGO_DB]
    collection = db[MONGO_COLLECTION]
    return collection


def write_mongo(collection, ip):
    collection.update_one({}, {"$set": {"ip": ip}}, upsert=True)


def main(args):
    collection = get_mongo()

    stored_ip = (collection.find_one() or {}).get("ip")

    current_ip = get_public_ip().strip()

    if current_ip != stored_ip:
        message = Mail(
            from_email=args.from_email,
            to_emails=args.to_email,
            subject=args.subject,
            plain_text_content=args.plain_text_content.format(current_ip=current_ip),
        )
        sg = sendgrid.SendGridAPIClient(api_key=SENDGRID_API_KEY)
        response = sg.send(message)

        if response.status_code == 202:
            write_mongo(collection, current_ip)

        print(response.status_code)
        print(response.body)
    else:
        print("IP addresses match.")


if __name__ == "__main__":
    args = parser.parse_args()

    main(args)
