#!/bin/bash
set -e

echo "Starting application setup..."

# Ensure SECRET_KEY_BASE is set
if [ -z "$SECRET_KEY_BASE" ]; then
  echo "Generating SECRET_KEY_BASE..."
  export SECRET_KEY_BASE=$(ruby -e 'require "securerandom"; puts SecureRandom.hex(64)')
  echo "SECRET_KEY_BASE=$SECRET_KEY_BASE" >> .env
fi

# Wait for the database to be ready
echo "Waiting for database to be ready..."
until mysqladmin ping -h"$DATABASE_HOST" --silent; do
    echo "Database is unavailable - waiting..."
    sleep 3
done
echo "Database is ready."

# Run database migrations
echo "Running database migrations..."
bin/rails db:migrate RAILS_ENV=production

# Ensure the database is seeded
echo "Seeding database..."
bin/rails db:seed RAILS_ENV=production

# Ensure admin user exists
echo "Ensuring admin user exists..."
bin/rails runner "User.find_or_create_by!(email: 'admin@example.com') do |u| u.password = 'adminPa$$w0rd'; u.password_confirmation = 'adminPa$$w0rd'; u.role = 'superadmin'; u.first_name = 'Super'; u.last_name = 'Admin'; end"

echo "Starting Rails server..."
exec bin/rails server -b 0.0.0.0 -p $PUMA_PORT

