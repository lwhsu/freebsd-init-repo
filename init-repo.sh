#!/bin/sh

repo=doc

fetch_url=https://git-dev.freebsd.org
push_url=ssh://git@gitrepo-dev.freebsd.org

git clone --verbose -o freebsd --config remote.freebsd.fetch='+refs/notes/*:refs/notes/*' ${fetch_url}/${repo}.git

cd ${repo}

git remote set-url --push freebsd ${push_url}/${repo}.git

pwent=$(ssh freefall.freebsd.org "getent passwd `whoami`")
git config user.name "$(echo ${pwent} | cut -d: -f 5)"
git config user.email $(echo ${pwent} | cut -d: -f 1)@FreeBSD.org

fetch https://cgit.freebsd.org/src/plain/tools/tools/git/hooks/prepare-commit-msg -o .git/hooks
chmod 755 .git/hooks/prepare-commit-msg

git config --add remote.freebsd.fetch '+refs/internal/*:refs/internal/*'
git fetch --verbose
git checkout -b admin internal/admin
git config push.default upstream

git checkout main
