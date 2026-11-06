#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

echo "Building Flutter web..."
flutter build web --release

echo "Deploying to Surge..."
echo "If this is your first deploy, run: npx surge login"
echo "Then run: npx surge ./build/web your-domain.surge.sh"
npx surge ./build/web finalink-loans.surge.sh
