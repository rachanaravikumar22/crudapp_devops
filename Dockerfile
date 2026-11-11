# Build stage
FROM ruby:3.4.12 AS build
WORKDIR /rails

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential default-libmysqlclient-dev git pkg-config libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
RUN chmod +x bin/* && SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Production stage
FROM ruby:3.4.12-slim AS runtime
WORKDIR /rails

ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    BUNDLE_WITHOUT="development:test"

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    default-libmysqlclient-dev libyaml-0-2 \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --system rails \
    && useradd --system --gid rails --create-home rails

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build --chown=rails:rails /rails /rails

RUN mkdir -p tmp/pids log storage && chown -R rails:rails tmp log storage

USER rails
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]