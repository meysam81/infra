# -*- coding: utf-8 -*-
"""Create the submissions table

Revision ID: 2d885f6895fb
Revises:
Create Date: 2024-07-06 11:00:55.180484

"""

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision = "2d885f6895fb"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "submissions",
        sa.Column("id", sa.Integer(), nullable=False, autoincrement=True),
        sa.Column("date", sa.Date(), nullable=False, default=sa.func.current_date()),
        sa.Column("title", sa.String(length=255), nullable=False),
        sa.Column("description", sa.Text(), nullable=False),
        sa.Column("subreddit", sa.String(length=50), nullable=False),
        sa.Column("is_submitted", sa.Boolean(), nullable=False, default=False),
        sa.PrimaryKeyConstraint("id"),
    )


def downgrade() -> None:
    op.drop_table("submissions")
