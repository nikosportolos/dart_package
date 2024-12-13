#!/bin/sh
echo
echo 📦 Installing Dependencies
npm install --no-audit
echo

echo
echo 🦠 Checking for Vulnerabilities
npm run audit
echo

echo
echo 🧾 Running lint check
npm run lint:check
echo

echo
echo 📝 Checking Code Formatting
npm run format:check
echo
