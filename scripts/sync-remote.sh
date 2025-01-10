#!/bin/bash

# Ensure the script stops on any error and is verbose for troubleshooting
set -e
set -o pipefail

# Define the NODE and repository root
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  NODE="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  NODE="macos"
else
  exit
fi

REPOSITORY_ROOT="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"

# Navigate to the repository root
cd "$REPOSITORY_ROOT"

# Add the NODE folder to the staging area
git add .

# Check if there are any changes staged for commit
if git diff --cached --exit-code > /dev/null; then
  echo "No changes detected for '$NODE'."
  exit 0
fi

# Create the "auto/{NODE}" branch if it doesn't exist and checkout
BRANCH="trunk/$NODE"

if ! git rev-parse --verify "$BRANCH" > /dev/null 2>&1; then
  git checkout -b "$BRANCH"
else
  git checkout "$BRANCH"
fi

# Get the current date and time for the commit message
TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S%z")

# Commit the changes with the required message
git commit -m "[$NODE] Auto-commit: $TIMESTAMP" --no-gpg-sign

# Push the changes to the remote repository
git push origin "$BRANCH"

echo "Changes for '$NODE' have been successfully committed and pushed to '$BRANCH'."
