#!/usr/bin/env bash
# Build a release APK and send it to testers through Firebase App Distribution.
#
#   scripts/distribute.sh you@example.com,friend@example.com
#
# Testers get an email for each new build and install it with one tap,
# either from the email link or from the Firebase App Tester app.
# Run `firebase login` once before the first use.
set -euo pipefail

cd "$(dirname "$0")/.."

TESTERS="${1:?usage: scripts/distribute.sh <tester emails, comma separated>}"
FIREBASE_APP_ID="1:919762640354:android:d440edce09da463ebcedbb"

# Each build needs a higher versionCode, or Android refuses to install it over the old one.
BUILD_NUMBER="$(git rev-list --count HEAD)"
NOTES="$(git log -5 --pretty='- %s')"

flutter build apk --release --build-number="$BUILD_NUMBER"

firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app "$FIREBASE_APP_ID" \
  --testers "$TESTERS" \
  --release-notes "$NOTES"
