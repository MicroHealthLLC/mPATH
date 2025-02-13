FROM ruby:3.1.0

WORKDIR /app

# Install dependencies first
COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.3.26 && bundle install

# Explicitly install Rails
RUN gem install rails --no-document --force

# Copy the entire application, including bin/rails
COPY . .

# Ensure bin/rails exists before setting permissions
RUN if [ ! -f "bin/rails" ]; then bundle exec rails app:update:bin; fi
RUN chmod +x bin/rails || true

# Expose Rails port
EXPOSE 3000

# Start Rails server
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
