#!/bin/bash
set -e

echo "Starting application setup..."

# Ensure we are in the correct directory
if [ -d "/var/www/mPATH" ]; then
  cd /var/www/mPATH
elif [ -d "/app" ]; then
  cd /app
else
  echo "App directory not found! Exiting..."
  exit 1
fi

# Ensure SECRET_KEY_BASE is set
if [ -z "$SECRET_KEY_BASE" ]; then
  echo "Generating SECRET_KEY_BASE..."
  export SECRET_KEY_BASE=$(ruby -e 'require "securerandom"; puts SecureRandom.hex(64)')
  echo "SECRET_KEY_BASE=$SECRET_KEY_BASE" >> .env
fi

# Run database migrations
echo "Running database migrations..."
bundle exec rake db:migrate RAILS_ENV=production

# Seed the database
echo "Seeding database..."
bundle exec rake db:seed RAILS_ENV=production

# Install any missing gems
echo "Installing missing gems..."
bundle check || bundle install

# Precompile assets if not already present
if ! ls public/packs/manifest.json &>/dev/null; then
  echo "Precompiling assets..."
  bundle exec rake assets:clobber
  bundle exec rake assets:precompile RAILS_ENV=production
else
  echo "Assets already precompiled."
fi

# Final ownership fix after all setup steps
echo "Ensuring correct file ownership..."
chown -R puma:puma /var/www/mPATH /usr/local/bundle

# Start Puma server as puma user
echo "Starting Puma server..."
exec gosu puma bin/rails server -b 0.0.0.0 -p $PUMA_PORT

