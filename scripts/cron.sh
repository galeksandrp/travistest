#!/usr/bin/env bash

PG_DUMPS_DIR="/root/cron/pgdumps"
PG_HOST_PREFIX="docker-pg1c-16-"

pgDump() {
    PG_DB_NAME="$1"

    mkdir -p "$PG_DUMPS_DIR"

    pg_dump -h "$PG_HOST_PREFIX$PG_DB_NAME" -U postgres -Fc -f "$PG_DUMPS_DIR/$PG_DB_NAME.pgsql" "$PG_DB_NAME"
}

yadiskBackup() {
    FILEPATH="$1"
    DIRPATH="$(dirname "$FILEPATH")"
    YADISK_FILENAME="$(date +'%Y_%m_%d_%H_%M_%S')_$(basename "$FILEPATH")"

    curl --upload-file "$FILEPATH" $(curl -H "Authorization: OAuth $YANDEX_DISK_TOKEN" -f "https://cloud-api.yandex.net:443/v1/disk/resources/upload?path=app:/$YADISK_FILENAME" | jq -r ".href")
}

yadiskDump() {
    PG_DB_NAME="$1"

    pgDump "$PG_DB_NAME" && yadiskBackup "$PG_DUMPS_DIR/$PG_DB_NAME.pgsql"
}

"$@"
