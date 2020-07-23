#!/bin/sh


## Fix wrong commit user: chmod +x /tmp/fix-git.sh && /tmp/fix-git.sh
cat << EOF > /tmp/fix-git.sh
#!/bin/sh
git filter-branch --env-filter '
WRONG_EMAIL="${1:-wrongmail@gmail.com}"
NEW_NAME="$(git config --global --get user.name)"
NEW_EMAIL="$(git config --global --get user.email)"

if [ "\$GIT_COMMITTER_EMAIL" = "\$WRONG_EMAIL" ]
then
    export GIT_COMMITTER_NAME="\$NEW_NAME"
    export GIT_COMMITTER_EMAIL="\$NEW_EMAIL"
fi
if [ "\$GIT_AUTHOR_EMAIL" = "\$WRONG_EMAIL" ]
then
    export GIT_AUTHOR_NAME="\$NEW_NAME"
    export GIT_AUTHOR_EMAIL="\$NEW_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
EOF
chmod +x /tmp/fix-git.sh
/tmp/fix-git.sh


# git pretty logs
git config --global alias.ll "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git ll