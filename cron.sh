#!/usr/bin/env sh
rm -f .git/index.lock

git -c core.autocrlf=input add mariadb/init/db.sql
git -c user.name="$GIT_USER_NAME" -c user.email=$GIT_USER_EMAIL commit -m "[UPD] price catalog"

git -c core.autocrlf=input add .
git -c user.name="$GIT_USER_NAME" -c user.email=$GIT_USER_EMAIL commit -m "[SEO] Upd"

GIT_REPO_URL=https://GIT_REPO_LOGIN:$GIT_REPO_TOKEN@github.com/$GIT_REPO_OWNER/$GIT_REPO_NAME.git

git push $GIT_REPO_URL $GIT_BRANCH_NAME || git log --reverse --pretty=format:"%H" | xargs -n1 -i sh -c "git push $GIT_REPO_URL {}:refs/heads/$GIT_BRANCH_NAME"
