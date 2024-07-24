#!/usr/bin/env nix-shell
#!nix-shell --quiet -i zsh -p nh

HOSTNAME=$(hostname)

# --------------------------------- Functions -------------------------------- #

revert() {
	git reset -q --hard "$rev"
	git stash pop -q
	exit 1
}

get_gen() {
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | awk '/current/ {print $1}'
}

# ---------------------------------- Script ---------------------------------- #

# Stash repo
rev=$(git rev-parse HEAD)
git stash push -q
git stash apply -q
trap 'revert' ERR

# Lock flake inputs
nix flake lock --option warn-dirty false

# Commit all changes
git add .
git commit -aq --allow-empty -m "$HOSTNAME: PREBUILD"

# Run nixos-rebuild
prev_gen=$(get_gen)
nh os switch .
next_gen=$(get_gen)

# Set commit message
git commit -aq --allow-empty --amend -m "$HOSTNAME: $prev_gen -> $next_gen"

# Push changes
# git push -q

git stash drop -q
exit 0
