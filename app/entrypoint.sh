#!/usr/bin/env sh

# Used as a convenience when setting up a new OJS install/container install. This file can be commented out in the
# docker-compose.yml and each command can be run individually within the container.
#
# NB: The `apache2-foregorund` at the end is the entry CMD for the php:8.0-apache image. Using this file as the
# entry point overwrites that instruction, so it must be manually called at the end of this file, otherwise no
# OJS site 🙁.

set -e

if [ ! -e "config.TEMPLATE.inc.php" ]; then
  echo "❌ Directory app/www does not contain a valid OJS installation. Skipping dependency checks..."
else
  echo "📦 Checking for npm/composer dependencies..."

  if [ ! -d "node_modules" ]; then
    npm install && npm run build > /dev/null
    echo "✅ Dependencies added via: npm install && npm run build"
  else
    echo "✅ Already installed: npm dependencies"
  fi

  if [ ! -d "lib/pkp/lib/vendor" ]; then
    composer --working-dir=lib/pkp install > /dev/null
    echo "✅ Dependencies added via: composer --working-dir=lib/pkp install"
  else
    echo "✅ Already installed: pkp-lib composer dependencies"
  fi

  if [ ! -d "plugins/generic/citationStyleLanguage/lib/vendor" ]; then
    composer --working-dir=plugins/generic/citationStyleLanguage install > /dev/null
    echo "✅ Dependencies added via: composer --working-dir=plugins/generic/citationStyleLanguage install"
  else
    echo "✅ Already installed: citationStyleLanguage composer dependencies"
  fi

  if [ ! -d "plugins/paymethod/paypal/vendor" ]; then
    composer --working-dir=plugins/paymethod/paypal install > /dev/null
    echo "✅ Dependencies added via: composer --working-dir=plugins/paymethod/paypal install"
  else
    echo "✅ Already installed: paypal composer dependencies"
  fi
fi

echo "ℹ️  npm and composer dependencies can be updated/reinstalled directly from within the container as needed"

echo "🚀 Starting Apache..."
apache2-foreground

