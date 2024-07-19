#!/usr/bin/env nix-shell
#!nix-shell --quiet -i zsh -p nh

# Function to get the current generation
get_gen() {
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | awk '/current/ {print $1}'
}

HOSTNAME=$(hostname)

# Lock flake inputs
nix flake lock --option warn-dirty false

# Commit all changes
git add .
git commit -aq --allow-empty -m "$HOSTNAME: PREBUILD"

# If commit fails, exit
if [ $? -ne 0 ]; then
    exit 1
fi

# Get previous generation number
prev_gen=$(get_gen)

# Run nixos-rebuild
nh os switch .

# If nixos-rebuild fails, undo the commit and exit
if [ $? -ne 0 ]; then
    git reset -q HEAD~
    exit 1
fi

# Get new generation number
next_gen=$(get_gen)

# Set commit message
git commit -aq --allow-empty --amend -m "$HOSTNAME: $prev_gen -> $next_gen"

# If commit fails, undo the commit and exit
if [ $? -ne 0 ]; then
    git reset -q HEAD~
    exit 1
fi

# Push changes
# git push -q

exit 0
