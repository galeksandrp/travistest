function githubRepoTransferUntouched {
	GITHUB_REPO_NAME="$1"
	GITHUB_REPO_API_URL=$(jq -r ".[]|select(.name==\"$GITHUB_REPO_NAME\").url" "$GITHUB_REPOS_PAGE")

	test $(git log --all --author=$GITHUB_EMAIL --oneline | wc -l) -eq 0 \
	&& echo -e "$GITHUB_REPO_NAME\t:untouched" \
	&& curl -H "Authorization: token $GITHUB_TOKEN" \
		-H 'Accept: application/vnd.github.nightshade-preview+json' \
		--data "{\"new_owner\": \"$GITHUB_UNTOUCHED_OWNER\"}" \
		"$GITHUB_REPO_API_URL/transfer"
}

function changeDirectory {
	cd "$1"
}

function githubRepoPullUpstream {
	GITHUB_REPO_SLUG="$1"
	GITHUB_REPO_NAME=$(echo "$GITHUB_REPO_SLUG" | tr '/' '_')
	GITHUB_REPO_API_URL=$(jq -r ".[]|select(.full_name==\"$GITHUB_REPO_SLUG\").url" "$GITHUB_REPOS_PAGE")
	GITHUB_REPO_UPSTREAM_URL=$(curl -H "Authorization: token $GITHUB_TOKEN" \
		"$GITHUB_REPO_API_URL" \
	| jq -r '.parent.clone_url')
	GITHUB_REPO_URL=$(jq -r ".[]|select(.full_name==\"$GITHUB_REPO_SLUG\").clone_url" "$GITHUB_REPOS_PAGE")
	GITHUB_REPO_DEFAULT_BRANCH=$(jq -r ".[]|select(.full_name==\"$GITHUB_REPO_SLUG\").default_branch" "$GITHUB_REPOS_PAGE")

	REPOSITORY_PARENT_DIRECTORY="$PWD"

	git clone "$GITHUB_REPO_UPSTREAM_URL" "$GITHUB_REPO_NAME" \
	&& changeDirectory "$GITHUB_REPO_NAME" \
	cp -Rf .git/refs/remotes/origin/* .git/refs/heads/ \
	&& rm -f .git/refs/heads/HEAD \
	&& cat .git/packed-refs \
	| grep ' refs/remotes/origin/' \
	| grep -v " refs/remotes/origin/$GITHUB_REPO_DEFAULT_BRANCH$" \
	| sed 's& refs/remotes/origin/& refs/heads/&' >> .git/packed-refs \
	&& git remote add fork "$GITHUB_REPO_URL" \
	&& git push fork --all \
	&& git push fork --tags \
	; cd "$REPOSITORY_PARENT_DIRECTORY" \
	; rm -rf "$GITHUB_REPO_NAME"
}

function githubReposPage {
  export GITHUB_REPOS_PAGE=$(readlink -f "$1")
  export WORKING_DIR=$(dirname "$GITHUB_REPOS_PAGE")

  cat "$GITHUB_REPOS_PAGE" \
  | jq -r ".[]|select(.owner.login|startswith(\"$GITHUB_LOGIN\"))|select(.fork).name" \
  | xargs -n1 -P8 -i bash -c ". \"$WORKING_DIR/functions.sh\" \
  && githubRepoPullUpstream"

  rm -r $(cat "$GITHUB_REPOS_PAGE" \
  | jq -r '.[].name')
}
