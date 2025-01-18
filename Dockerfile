FROM alpine

RUN apk update --no-cache && apk add --no-cache \
    git

RUN git config --global --add safe.directory '*'

RUN git clone --bare --depth 1 https://github.com/2833ru/2833ru.github.io.git /root/gitrepo/2833ru.github.io.git

WORKDIR /root/gitrepo/2833ru.github.io.git

RUN git worktree add /var/www/bitrix/upload/1c_catalog/import_files main

WORKDIR /var/www/bitrix/upload/1c_catalog/import_files

CMD ["sh", "-c", "git pull ; sleep 600"]
