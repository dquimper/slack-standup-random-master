FROM ruby:2.7.2

WORKDIR .

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["ruby", "standup_rollout.rb"]
