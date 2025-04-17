#!/bin/bash
set -e

# Read input arguments
TESTING_WORKFLOWS="$1"
LINTING_WORKFLOWS="$2"
BUILD_WORKFLOWS="$3"
DEPLOYMENT_WORKFLOWS="$4"

BRANCH_NAME="gh-actions-controller-update"
WORKFLOWS_DIR=".github/workflows"
TEMPLATES_REPO="https://github.com/BenFielder/github-actions-controller"

echo "Setting up the following workflows:"
echo "  - Testing:    $TESTING_WORKFLOWS"
echo "  - Linting:    $LINTING_WORKFLOWS"
echo "  - Build:      $BUILD_WORKFLOWS"
echo "  - Deployment: $DEPLOYMENT_WORKFLOWS"

# Setup git
git config --global user.name "github-actions[bot]"
git config --global user.email "github-actions[bot]@users.noreply.github.com"

# Create new branch
git checkout -b "$BRANCH_NAME" || git switch "$BRANCH_NAME"

# Clone templates
git clone "$TEMPLATES_REPO" templates

# Ensure workflows directory exists
mkdir -p "$WORKFLOWS_DIR"

# Copy selected workflows
if [[ "$TESTING_WORKFLOWS" == "true" ]]; then
  echo "✅ Copying testing workflows..."
  cp templates/templates/testing/*.yml "$WORKFLOWS_DIR/" || echo "No testing workflows found"
fi

if [[ "$LINTING_WORKFLOWS" == "true" ]]; then
  echo "✅ Copying linting workflows..."
  cp templates/templates/linting/*.yml "$WORKFLOWS_DIR/" || echo "No linting workflows found"
fi

if [[ "$BUILD_WORKFLOWS" == "true" ]]; then
  echo "✅ Copying build workflows..."
  cp templates/templates/building/*.yml "$WORKFLOWS_DIR/" || echo "No build workflows found"
fi

if [[ "$DEPLOYMENT_WORKFLOWS" == "true" ]]; then
  echo "✅ Copying deployment workflows..."
  cp templates/templates/deploying/*.yml "$WORKFLOWS_DIR/" || echo "No deployment workflows found"
fi

# Commit changes
git add "$WORKFLOWS_DIR" || true
git commit -m "chore: Update workflows" || echo "Nothing to commit"

# Push branch
git push -f origin "$BRANCH_NAME"

# Create PR
gh pr create --base main --head "$BRANCH_NAME" \
  --title "chore: GH Actions Controller Update" \
  --body "This PR updates the workflows via \`github-actions-controller\`."
