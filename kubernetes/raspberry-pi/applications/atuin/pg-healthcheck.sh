#!/usr/bin/env sh

set -eu

export POSTGRES_HOST=$(echo $ATUIN_DB_URI | awk -F/ '{print $3}' | awk -F@ '{print $2}')
export POSTGRES_USER=$(echo $ATUIN_DB_URI | awk -F/ '{print $3}' | awk -F: '{print $1}')
export POSTGRES_PASSWORD=$(echo $ATUIN_DB_URI | awk -F: '{print $3}' | awk -F@ '{print $1}')
export POSTGRES_DB=$(echo $ATUIN_DB_URI | awk -F/ '{print $4}' | awk -F? '{print $1}')

if pg_isready -h $POSTGRES_HOST -U $POSTGRES_USER -d $POSTGRES_DB -p 5432; then
    sleep 30
else
    exit 1
fi
