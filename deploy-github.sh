#!/bin/bash
# ================================================
# MoomooMath - Deploy to GitHub Pages
# ================================================
# Prerequisites: git, gh CLI (install: brew install gh)
# Run: bash deploy-github.sh
# ================================================

set -e
REPO="moomoomath"
DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "🐄 MoomooMath - GitHub Pages Deploy"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check dependencies
if ! command -v git &>/dev/null; then
  echo "❌ git not found. Install Xcode Command Line Tools:"
  echo "   xcode-select --install"
  exit 1
fi

if ! command -v gh &>/dev/null; then
  echo "❌ GitHub CLI (gh) not found. Install it:"
  echo "   brew install gh"
  echo "   Then run: gh auth login"
  exit 1
fi

# Check auth
if ! gh auth status &>/dev/null; then
  echo "❌ Not logged into GitHub. Run:"
  echo "   gh auth login"
  exit 1
fi

USER=$(gh api user --jq .login)
echo "✅ Logged in as: $USER"
echo ""

# Init git if needed
cd "$DIR"
if [ ! -d ".git" ]; then
  git init -b main
  echo "✅ Git repo initialized"
fi

# Create GitHub repo (skip if already exists)
if gh repo view "$USER/$REPO" &>/dev/null 2>&1; then
  echo "✅ GitHub repo already exists: $USER/$REPO"
else
  gh repo create "$REPO" --public --description "MoomooMath - Fun math adventures for kids" --confirm 2>/dev/null || \
  gh repo create "$REPO" --public --description "MoomooMath - Fun math adventures for kids"
  echo "✅ Created GitHub repo: $USER/$REPO"
fi

# Set remote
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/$USER/$REPO.git"

# Stage and commit
git add index.html start.sh deploy-github.sh
git diff --cached --quiet || git commit -m "Update MoomooMath game"

# Push
git push -u origin main --force
echo "✅ Code pushed to GitHub"

# Enable GitHub Pages
gh api "repos/$USER/$REPO/pages" \
  -X POST \
  -f "source[branch]=main" \
  -f "source[path]=/" \
  2>/dev/null || true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Done! Your site will be live at:"
echo ""
echo "   https://$USER.github.io/$REPO/"
echo ""
echo "Note: GitHub Pages takes 1-2 minutes"
echo "to go live for the first time."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
