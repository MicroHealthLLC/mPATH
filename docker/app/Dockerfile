# Use the official Ruby image with the required version
FROM ruby:3.1.0

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    curl dirmngr gnupg apt-transport-https ca-certificates \
    software-properties-common \
    default-mysql-client libmariadb-dev nginx \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (>=14.15.0) and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# Install Bundler version required by the project
RUN gem install bundler:2.3.26

# Copy Gemfile and Gemfile.lock before running `bundle install`
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies (without development/test)
RUN bundle install --without development test

# Copy the application code into the container
COPY . .

# Ensure `bin/rails` exists
RUN if [ ! -f "bin/rails" ]; then bundle exec rails app:update:bin; fi

# Set executable permissions
RUN chmod +x bin/rails || true

# Install JavaScript dependencies with Yarn
RUN yarn install

# Update Browserslist before asset precompilation
RUN npx update-browserslist-db@latest || true

# Precompile assets (ensure JavaScript runtime exists)
RUN SECRET_KEY_BASE=placeholder RAILS_ENV=production bundle exec rake assets:precompile


# Expose the default Rails port
EXPOSE 3000

# Start the Rails server when the container launches
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
