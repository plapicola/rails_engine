FROM ruby:2.4
MAINTAINER p@lapicola.com

RUN apt-get update

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install

COPY . ./

EXPOSE 3000

CMD ['bundle', 'exec', 'rails', 's']
