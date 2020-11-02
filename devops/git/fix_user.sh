#!/bin/bash

set -euo pipefail

# Usage: ./fix_user.sh 
NEW_NAME="$(git config --global --get user.name)"
NEW_EMAIL="$(git config --global --get user.email)"

git filter-branch --env-filter "
export GIT_COMMITTER_NAME='$NEW_NAME'
export GIT_COMMITTER_EMAIL='$NEW_EMAIL'
export GIT_AUTHOR_NAME='$NEW_NAME'
export GIT_AUTHOR_EMAIL='$NEW_EMAIL'
" --tag-name-filter cat -- --branches --tags

git log
