# ================================
# Builder stage (gems + JS deps)
# ================================
FROM ruby:3.1.0 AS builder
WORKDIR /var/www/mPATH

# System deps for native gems and Node build
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    curl dirmngr gnupg apt-transport-https ca-certificates \
    software-properties-common \
    default-mysql-client libmariadb-dev wget \
 && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
 && apt-get install -y nodejs \
 && npm install -g yarn \
 && rm -rf /var/lib/apt/lists/*

# Bundler
RUN gem install bundler:2.3.26

# Copy lockfiles first for better caching
COPY Gemfile Gemfile.lock package.json yarn.lock ./

# Install Ruby deps (prod only)
ENV RAILS_ENV=production
RUN bundle config set --local without 'development test' \
 && bundle install

# Install JS deps (prod only) — avoids Cypress/dev deps entirely
ENV NODE_ENV=production
RUN yarn install --production --frozen-lockfile

# Copy the rest of the app
COPY . .

# =================================
# Asset compilation stage
# =================================
FROM builder AS asset-compiler
WORKDIR /var/www/mPATH

ENV RAILS_ENV=production NODE_ENV=production

# puma user (for ownership during precompile)
RUN groupadd -r puma && useradd -r -g puma -d /var/www/mPATH puma

# dirs & perms
USER root
RUN mkdir -p /var/www/mPATH/tmp/pids /var/www/mPATH/tmp/cache /var/www/mPATH/log \
 && chown -R puma:puma /var/www/mPATH /usr/local/bundle /tmp \
 && chmod -R 755 /tmp

USER puma

# Tolerate webpacker or shakapacker projects
RUN bundle exec rails webpacker:install || true \
 && bundle exec rails shakapacker:install || true

# Precompile assets (ensure initialize_on_precompile is safe)
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:clobber assets:precompile

# Verify manifest
RUN test -f /var/www/mPATH/public/packs/manifest.json \
 && echo "manifest.json created successfully" || { echo "Error: manifest.json not found"; exit 1; }

# =====================
# Final runtime image
# =====================
FROM ruby:3.1.0
WORKDIR /var/www/mPATH

# Minimal runtime libs + Node.js for ExecJS/Uglifier at boot
RUN apt-get update -qq && apt-get install -y \
    curl dirmngr gnupg apt-transport-https ca-certificates \
    software-properties-common \
    default-mysql-client libmariadb3 wget \
 && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
 && apt-get install -y nodejs \
 && npm install -g yarn \
 && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.16/gosu-amd64" \
 && chmod +x /usr/local/bin/gosu \
 && gosu nobody true \
 && rm -rf /var/lib/apt/lists/*

# puma user
RUN groupadd -r puma && useradd -r -g puma -d /var/www/mPATH puma

# Bring in gems, app, and precompiled assets
COPY --from=asset-compiler --chown=puma:puma /usr/local/bundle /usr/local/bundle
COPY --from=asset-compiler --chown=puma:puma /var/www/mPATH /var/www/mPATH

# Entrypoint + perms
USER root
RUN chmod +x /var/www/mPATH/docker/app/entrypoint.sh \
 && mkdir -p /var/www/mPATH/tmp/pids /var/www/mPATH/tmp/cache /var/www/mPATH/log \
 && chown -R puma:puma /var/www/mPATH /usr/local/bundle /tmp \
 && chmod -R 755 /tmp

# Run as puma
USER puma

EXPOSE 8443
ENTRYPOINT ["/bin/bash", "/var/www/mPATH/docker/app/entrypoint.sh"]
