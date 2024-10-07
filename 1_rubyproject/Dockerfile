FROM ruby:3.1-bullseye

EXPOSE 3000

WORKDIR /usr/src/app

RUN git clone https://github.com/ruby/ruby.git

WORKDIR /app/ruby/rails-example-project/

RUN gem install bundler:2.3.3

RUN bundle install

COPY . .




