from ruby:2.5.0

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile

RUN bundle install

ADD "." /app

CMD [ "rails", "s" ]