#!/bin/bash
set -euo pipefail

VERSION="${1:?Usage: ./release.sh <VERSION>}"
ZIP_FILE="release/BuglyPro-${VERSION}.zip"
PODSPEC="BuglyPro.podspec"
REPO="BuglyDevTeam/BuglyPro-iOS"

if [ ! -f "$ZIP_FILE" ]; then
    echo "Error: $ZIP_FILE not found"
    exit 1
fi

echo "==> Releasing BuglyPro ${VERSION}"

echo "==> Updating podspec version..."
sed -i '' "s/s.version.*=.*/s.version      = \"${VERSION}\"/" "$PODSPEC"

echo "==> Committing changes..."
git add .
if git diff --cached --quiet; then
    echo "==> No changes to commit, skipping..."
else
    git commit -m "Release ${VERSION}"
fi

echo "==> Tagging ${VERSION}..."
git tag "${VERSION}"

echo "==> Pushing commit and tag..."
git push origin main
git push origin "${VERSION}"

echo "==> Creating GitHub Release and uploading zip..."
gh release create "${VERSION}" \
    "$ZIP_FILE" \
    --repo "$REPO" \
    --title "${VERSION}" \
    --notes "BuglyPro iOS SDK ${VERSION}"

echo "==> Done! BuglyPro ${VERSION} released successfully."
