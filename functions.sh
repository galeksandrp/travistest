function githubReposPageTransfer {
  GITHUB_REPOS_PAGE=$(readlink -f "$1")

  cat "$GITHUB_REPOS_PAGE" \
  | jq -r '.[].name' \
  | xargs -n1 -P8 -i bash -c "git clone \$(jq -r '.[]|select(.name==\"{}\").clone_url' '$1') \
  && cd {} \
  && test \$(git log --all --author=$GITHUB_EMAIL --oneline | wc -l) -eq 0 \
  && curl -H 'Authorization: token $GITHUB_TOKEN' -H 'Accept: application/vnd.github.nightshade-preview+json' --data '{\"new_owner\": \"$GITHUB_NEW_OWNER\"}' https://api.github.com/repos/\$(jq -r '.[]|select(.name==\"{}\").owner.login' '$GITHUB_REPOS_PAGE')/{}/transfer"

  cat "$GITHUB_REPOS_PAGE" \
  | jq -r '.[].name' \
  | xargs -n1 -P8 -i bash -c "rm -r {}"
}
