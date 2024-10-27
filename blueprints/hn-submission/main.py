#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import json
import logging
import os
from datetime import date
from typing import Optional

import psycopg2
from pydantic import BaseModel


def get_logger(level="INFO"):
    logger = logging.getLogger(__name__)
    logger.setLevel(level)

    formatter = logging.Formatter(
        "[%(levelname)s] %(asctime)s - %(filename)s:%(lineno)d - %(message)s"
    )

    stream_handler = logging.StreamHandler()
    stream_handler.setFormatter(formatter)
    logger.addHandler(stream_handler)

    return logger


DSN = os.environ["HACKERNEWS_DSN"]
LOG_LEVEL = os.environ.get("LOG_LEVEL", "INFO")
IS_GITHUB = os.getenv("CI") and os.getenv("GITHUB_OUTPUT")

logger = get_logger(LOG_LEVEL)

parser = argparse.ArgumentParser()
parser.add_argument("--submit", action="store_true")
parser.add_argument("-i", "--id", type=int, required=False)


class Submission(BaseModel):
    id: int
    title: str
    url: str


def get_connection():
    return psycopg2.connect(DSN)


def ping_database(conn):
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT 1")
        result = cursor.fetchone()
        if result[0] == 1:
            logger.info("Database connection successful")
    except (Exception, psycopg2.Error) as error:
        logger.error("Error while connecting to PostgreSQL", error)
        exit(1)


def get_latest_unsubmitted_story(conn) -> Optional[Submission]:
    cursor = conn.cursor()
    today = date.today()
    cursor.execute(
        """
      SELECT id, title, url
      FROM submissions
      WHERE is_submitted = false
      AND date = %s
      ORDER BY date DESC
      LIMIT 1
      """,
        (today,),
    )
    row = cursor.fetchone()
    if row:
        latest_story = Submission(id=row[0], title=row[1], url=row[2])
        return latest_story


def mark_submitted(conn, submission: Submission):
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE submissions SET is_submitted = true WHERE id = %s",
        (submission.id,),
    )
    conn.commit()


def githubify(submission: Optional[Submission]):
    found = False
    if submission:
        found = True

    found_jsonify = json.dumps(found)

    list_output = []
    if submission:
        for key, value in submission.model_dump().items():
            list_output.append(f"{key}={value}")

    github_output = "\n".join(list_output) + "\n"
    github_output_2 = f"found={found_jsonify}\n"

    logger.info(f"Writing the following to GitHub output:")
    logger.info(github_output)
    logger.info(github_output_2)

    with open(os.environ["GITHUB_OUTPUT"], "a") as f:
        rv = f.write(github_output)
        rv2 = f.write(github_output_2)

    logger.info(f"Written {rv + rv2} bytes to {os.environ['GITHUB_OUTPUT']}")


def fetch_story(conn):
    latest_story = get_latest_unsubmitted_story(conn)

    if latest_story:
        logger.info(latest_story.model_dump())

    if IS_GITHUB:
        githubify(latest_story)


def submit_story(conn, story_id):
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE submissions SET is_submitted = true WHERE id = %s",
        (story_id,),
    )
    result = cursor.rowcount
    conn.commit()
    logger.info(f"Story {story_id} is submitted. Rows updated: {result}")


def verify_args(args):
    if args.submit:
        assert args.id, "ID is required for submission"


def main(args):
    conn = get_connection()
    ping_database(conn)

    if args.submit:
        submit_story(conn, args.id)
    else:
        fetch_story(conn)

    conn.close()


if __name__ == "__main__":
    args = parser.parse_args()
    verify_args(args)
    main(args)
