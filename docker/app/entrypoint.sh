#!/usr/bin/env bash
set -euo pipefail

APP_HOME="/var/www/mPATH"
PORT="${PORT:-8443}"

echo "Starting mPATH (entrypoint) ..."
cd "$APP_HOME"

# Require secrets (do not silently generate in prod)
if [[ -z "${SECRET_KEY_BASE:-}" ]]; then
  echo "ERROR: SECRET_KEY_BASE is not set."
  exit 1
fi
if [[ -z "${RAILS_MASTER_KEY:-}" && ! -f "config/master.key" ]]; then
  echo "ERROR: RAILS_MASTER_KEY not set and config/master.key not present."
  exit 1
fi

# Optional: wait for DB (Lightsail) if requested
if [[ "${DB_WAIT:-0}" == "1" ]]; then
  echo "Waiting for database (up to ${DB_WAIT_TIMEOUT:-60}s)..."
  end=$((SECONDS + ${DB_WAIT_TIMEOUT:-60}))
  while ! bundle exec ruby -e 'require "uri"; require "mysql2";
    u=URI(ENV["DATABASE_URL"]);
    Mysql2::Client.new(host:u.host,port:(u.port||3306),username:u.user,password:u.password).close' >/dev/null 2>&1; do
    [[ $SECONDS -ge $end ]] && { echo "DB not reachable in time"; exit 1; }
    sleep 2
  done
fi

# Migrations (skip by default on steady-state ECS tasks)
if [[ "${SKIP_MIGRATIONS:-1}" != "1" ]]; then
  echo "Running migrations..."
  bundle exec rails db:migrate
else
  echo "Skipping migrations (SKIP_MIGRATIONS=${SKIP_MIGRATIONS:-1})."
fi

# Seeds only when explicitly requested
if [[ "${RUN_SEEDS:-0}" == "1" ]]; then
  echo "Seeding database (RUN_SEEDS=1)..."
  bundle exec rails db:seed
else
  echo "Skipping seeds."
fi

echo "Booting Puma on 0.0.0.0:${PORT} (HTTP; TLS at ALB)..."
# We're already USER puma; gosu path is here only if this ever runs as root
if [[ "$(id -u)" -eq 0 ]]; then
  exec gosu puma:puma bundle exec puma -C config/puma.rb -b tcp://0.0.0.0:${PORT}
else
  exec bundle exec puma -C config/puma.rb
fi
