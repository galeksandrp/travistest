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

function githubRepoPullUpstream {
	GITHUB_REPO_NAME="$1"
	GITHUB_REPO_API_URL=$(jq -r ".[]|select(.name==\"$GITHUB_REPO_NAME\").url" "$GITHUB_REPOS_PAGE")
	GITHUB_REPO_UPSTREAM_URL=$(curl -H "Authorization: token $GITHUB_TOKEN" \
		"$GITHUB_REPO_API_URL" \
	| jq -r '.parent.clone_url')
	GITHUB_REPO_URL=$(jq -r ".[]|select(.name==\"$GITHUB_REPO_NAME\").clone_url" "$GITHUB_REPOS_PAGE")
	GITHUB_REPO_DEFAULT_BRANCH=$(jq -r ".[]|select(.name==\"$GITHUB_REPO_NAME\").default_branch" "$GITHUB_REPOS_PAGE")
	
	git clone "$GITHUB_REPO_UPSTREAM_URL" "$GITHUB_REPO_NAME" \
	&& cd "$GITHUB_REPO_NAME" \
	cp -Rf .git/refs/remotes/origin/* .git/refs/heads/ \
	&& rm -f .git/refs/heads/HEAD \
	&& cat .git/packed-refs \
	| grep ' refs/remotes/origin/' \
	| grep -v " refs/remotes/origin/$GITHUB_REPO_DEFAULT_BRANCH$" \
	| sed 's& refs/remotes/origin/& refs/heads/&' >> .git/packed-refs \
	&& git remote add fork "$GITHUB_REPO_URL" \
	&& git push fork --all \
	&& git push fork --tags
}

function githubRepoTransferMerged {
	GITHUB_REPO_NAME="$1"
	GITHUB_REPO_API_URL=$(jq -r ".[]|select(.name==\"$GITHUB_REPO_NAME\").url" "$GITHUB_REPOS_PAGE")
	GITHUB_REPO_URL=$(jq -r ".[]|select(.name==\"$GITHUB_REPO_NAME\").clone_url" "$GITHUB_REPOS_PAGE")
	
	GITHUB_REPO_UPSTREAM_PATCHES_HASH=$(git log --all --author=$GITHUB_EMAIL --pretty=format:'%H' \
	| xargs git show \
	| git patch-id \
	| cut -d ' ' -f1 \
	| sort \
	| uniq \
	| sha256sum \
	| head -c 64)
	
	git fetch --all
	
	GITHUB_REPO_PATCHES_HASH=$(git log --all --author=$GITHUB_EMAIL --pretty=format:'%H' \
	| xargs git show \
	| git patch-id \
	| cut -d ' ' -f1 \
	| sort \
	| uniq \
	| sha256sum \
	| head -c 64)
	
	githubRepoTransferUntouched "$GITHUB_REPO_NAME" \
	&& return
	
	test $GITHUB_REPO_UPSTREAM_PATCHES_HASH = $GITHUB_REPO_PATCHES_HASH \
	&& echo -e "$GITHUB_REPO_NAME\t:all my patches merged" \
	&& curl -H "Authorization: token $GITHUB_TOKEN" \
		-H 'Accept: application/vnd.github.nightshade-preview+json' \
		--data "{\"new_owner\": \"$GITHUB_MERGED_OWNER\"}" \
		"$GITHUB_REPO_API_URL/transfer"
}

function githubRepoTransferCI {
	GITHUB_REPO_NAME="$1"
	GITHUB_REPO_API_URL=$(jq -r ".[]|select(.name==\"$GITHUB_REPO_NAME\").url" "$GITHUB_REPOS_PAGE")

	test $(git log --all --author=$GITHUB_EMAIL --oneline | wc -l) -gt 0 \
	&& test $(git log --all --author=$GITHUB_EMAIL --pretty= --name-only | grep -v '\.yml$' | wc -l) -eq 0 \
	&& echo -e "$GITHUB_REPO_NAME\t:ci" \
	&& curl -H "Authorization: token $GITHUB_TOKEN" \
		-H 'Accept: application/vnd.github.nightshade-preview+json' \
		--data "{\"new_owner\": \"$GITHUB_CI_OWNER\"}" \
		"$GITHUB_REPO_API_URL/transfer"
}

function githubReposPage {
  export GITHUB_REPOS_PAGE=$(readlink -f "$1")
  export WORKING_DIR=$(dirname "$GITHUB_REPOS_PAGE")

  cat "$GITHUB_REPOS_PAGE" \
  | jq -r '.[]|select(.fork).name' \
  | xargs -n1 -P8 -i bash -c ". \"$WORKING_DIR/functions.sh\" \
  && githubRepoPullUpstream {} \
  ; githubRepoTransferMerged {} \
  ; githubRepoTransferCI {}"
  
  cat "$GITHUB_REPOS_PAGE" \
  | jq -r '.[]|select(.fork==false).name' \
  | xargs -n1 -P8 -i bash -c "git clone \$(jq -r '.[]|select(.name==\"{}\").clone_url' '$GITHUB_REPOS_PAGE') \
  && . \"$WORKING_DIR/functions.sh\" \
  && cd {} \
  && githubRepoTransferUntouched {}"

  rm -r $(cat "$GITHUB_REPOS_PAGE" \
  | jq -r '.[].name')
}
