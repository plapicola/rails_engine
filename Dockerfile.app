FROM ruby:2.4
MAINTAINER p@lapicola.com

RUN apt-get update

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install

COPY . ./

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
