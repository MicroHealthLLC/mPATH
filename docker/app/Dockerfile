# Builder stage for installing dependencies
FROM ruby:3.1.0 AS builder

WORKDIR /var/www/mPATH

# Install system dependencies (build-essential for native gems like mysql2, Node.js for Webpacker)
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    curl dirmngr gnupg apt-transport-https ca-certificates \
    software-properties-common \
    default-mysql-client libmariadb-dev wget \
 && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
 && apt-get install -y nodejs \
 && npm install -g yarn \
 && rm -rf /var/lib/apt/lists/*

# Install Bundler
RUN gem install bundler:2.3.26

# Copy lockfiles for caching
COPY Gemfile Gemfile.lock package.json yarn.lock ./

# Bundle config and install (production only)
RUN bundle config set --local without 'development test' \
 && bundle install

# Set production env for JS installs
ENV NODE_ENV=production

# Install JS dependencies (production only)
RUN yarn install --production --frozen-lockfile

# Install all Node dependencies
ENV NODE_ENV=production

RUN npm install

# Copy full app code
COPY . .

# Asset compilation stage (mimic runtime environment)
FROM builder AS asset-compiler

WORKDIR /var/www/mPATH

# Set production environment to match runtime
ENV RAILS_ENV=production NODE_ENV=production

# Create puma user and group (needed for permissions in asset compilation)
RUN groupadd -r puma && useradd -r -g puma -d /var/www/mPATH puma

# Set permissions as root
USER root
RUN mkdir -p /var/www/mPATH/tmp/pids /var/www/mPATH/tmp/cache /var/www/mPATH/log \
 && chown -R puma:puma /var/www/mPATH /usr/local/bundle /tmp \
 && chmod -R 755 /tmp

# Switch to puma user for asset compilation (mimics runtime)
USER puma

# Install Webpacker/Shakapacker (no-op if already installed)
RUN bundle exec rails webpacker:install || true \
 && bundle exec rails shakapacker:install || true

# Precompile assets (use dummy secret; ensure config.assets.initialize_on_precompile = false in config/application.rb)
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:clobber assets:precompile

# Verify manifest.json exists (debugging step)
RUN test -f /var/www/mPATH/public/packs/manifest.json && echo "manifest.json created successfully" || { echo "Error: manifest.json not found"; exit 1; }

# Final runtime stage
FROM ruby:3.1.0

WORKDIR /var/www/mPATH

# Install minimal runtime dependencies (libmariadb3 for mysql2 runtime)
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

# Create puma user and group
RUN groupadd -r puma && useradd -r -g puma -d /var/www/mPATH puma

# Copy bundled gems, app code, and precompiled assets from asset-compiler stage
COPY --from=asset-compiler --chown=puma:puma /usr/local/bundle /usr/local/bundle
COPY --from=asset-compiler --chown=puma:puma /var/www/mPATH /var/www/mPATH

# Set permissions as root
USER root
RUN chmod +x /var/www/mPATH/docker/app/entrypoint.sh \
 && mkdir -p /var/www/mPATH/tmp/pids /var/www/mPATH/tmp/cache /var/www/mPATH/log \
 && chown -R puma:puma /var/www/mPATH /usr/local/bundle /tmp \
 && chmod -R 755 /tmp

# Switch to puma user
USER puma

# Expose port for Puma
EXPOSE 8443

# Entrypoint
ENTRYPOINT ["/bin/bash", "/var/www/mPATH/docker/app/entrypoint.sh"]