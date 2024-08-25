# -*- coding: utf-8 -*-
"""set is_submitted default value to false

Revision ID: d99f7145bb83
Revises: 2d885f6895fb
Create Date: 2024-08-25 17:49:53.699998

"""

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision = "d99f7145bb83"
down_revision = "2d885f6895fb"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.alter_column(
        "submissions",
        "is_submitted",
        existing_type=sa.BOOLEAN(),
        server_default="false",
        existing_nullable=False,
    )


def downgrade() -> None:
    op.alter_column(
        "submissions",
        "is_submitted",
        existing_type=sa.BOOLEAN(),
        server_default=None,
        existing_nullable=False,
    )
