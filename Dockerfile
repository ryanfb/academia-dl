FROM ruby:latest

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

VOLUME /data
WORKDIR /data
ENTRYPOINT ["bundle", "exec", "/usr/src/app/academia-dl.rb"]
