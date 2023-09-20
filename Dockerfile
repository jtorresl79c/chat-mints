# --------------------------------------------------------------
# Builder
# This stage is used to build our application according to the following steps:
# Install gems (bundle install)
# Install JavaScript dependencies (yarn install)
# Pre-compile rails assets (assets:precompile)
# --------------------------------------------------------------
FROM us-central1-docker.pkg.dev/shared-impl/cloud-run-implementations/base-image as builder
# Create /app directory as environment variable to use along the image
ENV APP_HOME /app
# Set current work directory to /app
WORKDIR $APP_HOME
# Copy all Gemfile files from our application code to our current work directory (/app)
COPY Gemfile* $APP_HOME/
# Set our rails environment and secret key as environment variables
ENV RAILS_ENV=production
ENV SECRET_KEY_BASE "495668be9225520a1dbc5cle1d439b38e27ae89a198ec3bef4608f366364747beebf57efcd46137bfc8e922a0b0b7f54f348fae3b9ec8eff9eea9409e077683361f"
# Install application gems using the following parameters
# --deployment: installs gems to the vendor/bundle directory in the application.
# --jobs: The maximum number of parallel download and install jobs. The default is the number of available processors.
# --without development test: Exclude this environments from build. (Build just for production)
RUN gem update --system
RUN bundle install --deployment --jobs=4 --without development test
# Copy package.json and yarn.lock from our application code to our current work directory (/app)
COPY package.json yarn.lock $APP_HOME/
# Install JavaScript dependencies
RUN yarn install
# Copy all our application code to our current work directory (/app)
COPY . $APP_HOME
# Pre-compile our rails application assets in production environment
RUN bundle exec rake assets:precompile RAILS_ENV=production
# Remove node_modules directory and all generated rails temp files
RUN rm -rf $APP_HOME/node_modules && rm -rf $APP_HOME/tmp/*

# --------------------------------------------------------------
# Runtime
# This stage is exclusive for run our application.
# --------------------------------------------------------------
FROM ruby:3.0.0-alpine3.13 as runtime
# Update and upgrade alphine packages
RUN apk update && apk upgrade
# Add required packages to can build our application. (Node and yarn needs the specified version)
RUN apk add --update alpine-sdk python3 shared-mime-info gcompat tzdata && rm -rf /var/cache/apk/*
# Create /app directory as environment variable to use along the image
ENV APP_HOME /app
# Set current work directory to /app
WORKDIR $APP_HOME
# Copy from builder stage the content in /app (application content with compiled assets)
COPY --from=builder /app $APP_HOME
# Setup rails environment and bundle settings
ENV APP_ENV="production"
ENV THREAD_COUNT=16
ENV RAILS_ENV="production"
ENV SECRET_KEY_BASE "495668be9225520a1dbc5cle1d439b38e27ae89a198ec3bef4608f366364747beebf57efcd46137bfc8e922a0b0b7f54f348fae3b9ec8eff9eea9409e077683361f"
ENV RAILS_LOG_TO_STDOUT=true

RUN bundle config --local path vendor/bundle
RUN bundle config --local without development:test:assets
# Required environment variable to expose compiled js assets
ENV RAILS_SERVE_STATIC_FILES=true
# Expose port to cloud run service (8080)
EXPOSE 8080
# Remove tmp generated files and run rails serve
RUN rm -f tmp/pids/server.pid
CMD bundle exec rails s -b 0.0.0.0 -p 8080