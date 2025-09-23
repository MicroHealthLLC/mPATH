# Use the official Ruby image
FROM ruby:3.1.0

# Set the working directory inside the container
WORKDIR /var/www/mPATH

# Install system dependencies, including gosu (no Nginx here to keep it clean)
RUN apt-get update -qq && apt-get install -y \
    curl dirmngr gnupg apt-transport-https ca-certificates \
    software-properties-common \
    default-mysql-client libmariadb-dev wget \
 && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.16/gosu-amd64" \
 && chmod +x /usr/local/bin/gosu \
 && gosu nobody true \
 && rm -rf /var/lib/apt/lists/*

# Install Node.js (>=14.15.0) and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
 && apt-get install -y nodejs \
 && npm install -g yarn

# Install Bundler
RUN gem install bundler:2.3.26

# Create puma user and group
RUN groupadd -r puma && useradd -r -g puma -d /var/www/mPATH puma

# Copy the application source code
COPY . .

# Set entrypoint permissions while still root
RUN chmod +x /var/www/mPATH/docker/app/entrypoint.sh
USER root
# Single ownership/permissions pass (no duplicates later)
RUN mkdir -p /var/www/mPATH/tmp/pids /var/www/mPATH/tmp/cache /var/www/mPATH/log \
 && chown -R puma:puma /var/www/mPATH /usr/local/bundle /tmp \
 && chmod -R 755 /tmp

# Switch to the puma user for security
USER puma

# Bundler config and install (writes into /usr/local/bundle which puma now owns)
RUN bundle config set --local without 'development test' \
 && bundle install

# Install JavaScript dependencies
RUN yarn install --silent || true

# Ensure Webpacker/Shakapacker is installed (no-op if already present)
RUN NODE_ENV=production RAILS_ENV=production bundle exec rails webpacker:install || true
RUN NODE_ENV=production RAILS_ENV=production bundle exec rails shakapacker:install || true

# Precompile Rails assets (build-time placeholders only)
RUN SECRET_KEY_BASE=placeholder \
    DATABASE_URL=mysql2://mpath_user:mpath_pass@mysql/mpath \
    RAILS_ENV=production \
    bundle exec rake assets:clobber assets:precompile

# Expose port for Puma (plain HTTP; TLS terminates at ALB)
EXPOSE 8443

# Entrypoint
ENTRYPOINT ["/bin/bash", "/var/www/mPATH/docker/app/entrypoint.sh"]
