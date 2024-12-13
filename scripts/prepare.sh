#!/bin/sh

echo
echo 📦 Installing Dependencies
npm install
echo

echo
echo 📝 Checking Code Formatting
npm run format
echo

echo
echo 🧾 Running lint check
npm run lint
echo
