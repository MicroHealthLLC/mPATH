# Use the official Ruby image
FROM ruby:3.1.0

# Set the working directory inside the container
WORKDIR /var/www/mPATH

# Install system dependencies, including gosu
RUN apt-get update -qq && apt-get install -y \
    curl dirmngr gnupg apt-transport-https ca-certificates \
    software-properties-common \
    default-mysql-client libmariadb-dev nginx wget \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.16/gosu-amd64" \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (>=14.15.0) and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# Install Bundler
RUN gem install bundler:2.3.26

# Create puma user and group
RUN groupadd -r puma && useradd -r -g puma -d /var/www/mPATH puma

# Copy the application source code
COPY . .

# Ensure correct ownership of the application directory and dependencies
RUN chown -R puma:puma /var/www/mPATH /usr/local/bundle
RUN chown -R puma:puma /tmp && chmod -R 755 /tmp

# Switch to the puma user for security
USER puma

# Set Bundler configuration before installing gems
RUN bundle config set --local without 'development test' && \
    bundle install

# Install JavaScript dependencies
RUN yarn install --silent

# Ensure Webpacker/Shakapacker is installed
RUN NODE_ENV=production RAILS_ENV=production bundle exec rails webpacker:install || true
RUN NODE_ENV=production RAILS_ENV=production bundle exec rails shakapacker:install || true

# Precompile Rails assets
RUN SECRET_KEY_BASE=placeholder RAILS_ENV=production bundle exec rake assets:precompile


# Switch back to root for final setup
USER root

# Final chown to ensure correct ownership
RUN chown -R puma:puma /var/www/mPATH /usr/local/bundle

# Expose port for Puma
EXPOSE 8443

# Set the entrypoint script with correct permissions
RUN chmod +x /var/www/mPATH/docker/app/entrypoint.sh
ENTRYPOINT ["/bin/bash", "/var/www/mPATH/docker/app/entrypoint.sh"]

