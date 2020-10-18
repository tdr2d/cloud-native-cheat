#!/bin/sh

set -euo pipefail

# Usage: ./

wrong_email=$1
to_user=$2

# Usage: ./fix_user.sh wrongmail@gmail.com
WRONG_EMAIL="${1:-wrongmail@gmail.com}"
NEW_NAME="$(git config --global --get user.name)"
NEW_EMAIL="$(git config --global --get user.email)"

git filter-branch --env-filter '
if [ "$GIT_COMMITTER_EMAIL" = "$WRONG_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$NEW_NAME"
    export GIT_COMMITTER_EMAIL="$NEW_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$WRONG_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$NEW_NAME"
    export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
EOF

git log