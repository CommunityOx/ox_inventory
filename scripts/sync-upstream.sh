#!/usr/bin/env bash
set -e

# go to repo root
cd "$(git rev-parse --show-toplevel)" || exit 1

# make sure upstream exists
UPSTREAM_URL="https://github.com/communityox/ox_inventory.git"
if ! git remote | grep -q "^upstream$"; then
    echo "Adding upstream remote..."
    git remote add upstream "$UPSTREAM_URL"
fi

# stash local changes (tracked + untracked)
STASH_NAME="auto-sync stash"
git stash push -u -m "$STASH_NAME"

# fetch updates from upstream
git fetch upstream

# update main branch
git checkout main
git merge upstream/main
git push origin main

# merge main into development
git checkout development
git merge main

# safely restore stash if it exists
if git stash list | grep -q "$STASH_NAME"; then
    echo "Restoring local changes..."
    git stash pop
else
    echo "No auto-sync stash to restore."
fi

echo "Sync complete"
