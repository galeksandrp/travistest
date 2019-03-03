function githubRepoTransferUntouched {
	GITHUB_REPO_NAME="$1"

	test $(git log --all --author=$GITHUB_EMAIL --oneline | wc -l) -eq 0 \
	&& echo -e "$GITHUB_REPO_NAME\t:untouched" \
	&& curl -H "Authorization: token $GITHUB_TOKEN" \
		-H 'Accept: application/vnd.github.nightshade-preview+json' \
		--data "{\"new_owner\": \"$GITHUB_UNTOUCHED_OWNER\"}" \
		https://api.github.com/repos/$(jq -r ".[]|select(.name==\"$GITHUB_REPO_NAME\").owner.login" "$GITHUB_REPOS_PAGE")/$GITHUB_REPO_NAME/transfer
}

function githubRepoTransferMerged {
	GITHUB_REPO_NAME="$1"
	GITHUB_NAME=$(jq -r ".[]|select(.name==\"$GITHUB_REPO_NAME\").owner.login" "$GITHUB_REPOS_PAGE")

	curl -H "Authorization: token $GITHUB_TOKEN" \
		https://api.github.com/repos/$GITHUB_NAME/$GITHUB_REPO_NAME > "$WORKING_DIR/$GITHUB_REPO_NAME.json"
	GITHUB_REPO_UPSTREAM_NAME=$(jq -r '.parent.owner.login' "$WORKING_DIR/$GITHUB_REPO_NAME.json")
	
	GITHUB_REPO_COMMITS_HASH=$(git log --all --author=$GITHUB_EMAIL --pretty=format:"%H" \
	| sort \
	| uniq \
	| sha256sum \
	| head -c 64)
	
	git clone $(jq -r '.parent.clone_url' "$WORKING_DIR/$GITHUB_REPO_NAME.json") "/tmp/$GITHUB_REPO_NAME"
	GITHUB_REPO_UPSTREAM_COMMITS_HASH=$(git -C "/tmp/$GITHUB_REPO_NAME" log --all --author=$GITHUB_EMAIL --pretty=format:"%H" \
	| sort \
	| uniq \
	| sha256sum \
	| head -c 64)
	
	test $GITHUB_REPO_UPSTREAM_COMMITS_HASH = $GITHUB_REPO_COMMITS_HASH \
	&& echo -e "$GITHUB_REPO_NAME\t:all my commits merged" \
	&& curl -H "Authorization: token $GITHUB_TOKEN" \
		-H 'Accept: application/vnd.github.nightshade-preview+json' \
		--data "{\"new_owner\": \"$GITHUB_MERGED_OWNER\"}" \
		https://api.github.com/repos/$GITHUB_NAME/$GITHUB_REPO_NAME/transfer
}

function githubReposPage {
  export GITHUB_REPOS_PAGE=$(readlink -f "$1")
  export WORKING_DIR=$(dirname "$GITHUB_REPOS_PAGE")

  cat "$GITHUB_REPOS_PAGE" \
  | jq -r '.[].name' \
  | xargs -n1 -P8 -i bash -c "git clone \$(jq -r '.[]|select(.name==\"{}\").clone_url' '$GITHUB_REPOS_PAGE') \
  && . \"$WORKING_DIR/functions.sh\" \
  && cd {} \
  && githubRepoTransferUntouched {} \
  || (jq -e '.[]|select(.name==\"{}\").fork' '$GITHUB_REPOS_PAGE' > /dev/null \
  && githubRepoTransferMerged {})"

  cat "$GITHUB_REPOS_PAGE" \
  | jq -r '.[].name' \
  | xargs -n1 -P8 -i bash -c "rm -r {}"
}
