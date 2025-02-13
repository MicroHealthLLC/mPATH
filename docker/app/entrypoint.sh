#!/bin/bash
set -e

echo "Starting application setup..."

# Ensure SECRET_KEY_BASE is set
if [ -z "$SECRET_KEY_BASE" ]; then
  echo "Generating SECRET_KEY_BASE..."
  export SECRET_KEY_BASE=$(ruby -e 'require "securerandom"; puts SecureRandom.hex(64)')
  echo "SECRET_KEY_BASE=$SECRET_KEY_BASE" >> .env
fi

# Precompile assets (only if they are missing)
if [ ! -d "/app/public/assets" ]; then
  echo "Precompiling assets..."
  bundle exec rake assets:precompile RAILS_ENV=production
fi

# Run database migrations
echo "Running database migrations..."
bin/rails db:migrate RAILS_ENV=production

# Start the Rails server
echo "Starting Rails server..."
exec bin/rails server -b 0.0.0.0 -p $PUMA_PORT
