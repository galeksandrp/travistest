#!/usr/bin/env bash

# Base functions

yandex_disk_get_endpoint () {
	echo "https://cloud-api.yandex.net:443/v1/disk"
}

yandex_disk_get_path_app_path () {
	echo "app%3A%2F"
}

yandex_disk_get_default_items_limit () {
	echo 999
}

# Other functions

yandex_disk_list_app_filepathes () {
	YANDEX_DISK_TOKEN="$1"
	YANDEX_DISK_ITEMS_LIMIT=${2:-$(yandex_disk_get_default_items_limit)}

	curl -L -H "Authorization: OAuth $YANDEX_DISK_TOKEN" \
		"$(yandex_disk_get_endpoint)/resources?path=$(yandex_disk_get_path_app_path)&fields=_embedded.items.path&limit=$YANDEX_DISK_ITEMS_LIMIT" \
	| jq -r '._embedded.items[].path'
}

yandex_disk_list_app_filepathes_encoded () {
	YANDEX_DISK_TOKEN="$1"
	SCRIPT_FILEPATH="$0"

	yandex_disk_list_app_filepathes "$YANDEX_DISK_TOKEN" \
	| xargs -n1 -i bash -c "'$SCRIPT_FILEPATH' yandex_disk_filepath_to_app_filepath '{}'"
}

yandex_disk_filepath_to_app_filepath () {
	echo "$1" | sed "s&disk:/Приложения/SMT/&$(yandex_disk_get_path_app_path)&"
}

yandex_disk_filepath_to_download_url () {
	YANDEX_DISK_TOKEN="$1"
	YANDEX_DISK_PATH_FILEPATH="$2"

	curl -L -H "Authorization: OAuth $YANDEX_DISK_TOKEN" \
		"$(yandex_disk_get_endpoint)/resources/download?path=$YANDEX_DISK_PATH_FILEPATH" \
	| jq -r '.href'
}

yandex_disk_download_filepath () {
	YANDEX_DISK_TOKEN="$1"
	YANDEX_DISK_PATH_FILEPATH="$2"
	
	curl -L -H "Authorization: OAuth $YANDEX_DISK_TOKEN" \
		"$(yandex_disk_filepath_to_download_url "$YANDEX_DISK_TOKEN" "$YANDEX_DISK_PATH_FILEPATH")"
}

yandex_disk_upload_filepath () {
	YANDEX_DISK_TOKEN="$1"
	YANDEX_DISK_PATH_FILEPATH="$2"
	
	curl -L -H "Authorization: OAuth $YANDEX_DISK_TOKEN" \
		"$(yandex_disk_get_upload_url "$YANDEX_DISK_TOKEN" "$YANDEX_DISK_PATH_FILEPATH")" -T -
}

yandex_disk_get_upload_url () {
	YANDEX_DISK_TOKEN="$1"
	YANDEX_DISK_PATH_FILEPATH="$2"

	curl -L -H "Authorization: OAuth $YANDEX_DISK_TOKEN" \
		"$(yandex_disk_get_endpoint)/resources/upload?path=$YANDEX_DISK_PATH_FILEPATH" \
	| jq -r '.href'
}

yandex_disk_migrate_filepath () {
	YANDEX_DISK_SOURCE_TOKEN="$1"
	YANDEX_DISK_DESTINATION_TOKEN="$2"
	YANDEX_DISK_PATH_FILEPATH="$3"

	yandex_disk_download_filepath "$YANDEX_DISK_SOURCE_TOKEN" "$YANDEX_DISK_PATH_FILEPATH" \
	| yandex_disk_upload_filepath "$YANDEX_DISK_DESTINATION_TOKEN" "$YANDEX_DISK_PATH_FILEPATH"
}

yandex_disk_migrate_filepathes () {
	YANDEX_DISK_SOURCE_TOKEN="$1"
	YANDEX_DISK_DESTINATION_TOKEN="$2"
	SCRIPT_FILEPATH="$0"

	yandex_disk_list_app_filepathes_encoded "$YANDEX_DISK_SOURCE_TOKEN" \
	| xargs -n1 -i bash -c "'$SCRIPT_FILEPATH' yandex_disk_migrate_filepath '$YANDEX_DISK_SOURCE_TOKEN' '$YANDEX_DISK_DESTINATION_TOKEN' '{}'"
}

${1:-yandex_disk_migrate_filepathes} "${@:2}"
