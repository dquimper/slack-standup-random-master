FROM ruby:2.7.2

WORKDIR .

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENV STANDUPROLLOUT_WEBHOOK_URL=https://hooks.slack.com/services/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
ENV STANDUPROLLOUT_CHANNEL='#secret-gcore'
ENV STANDUPROLLOUT_AT_HANDLE='<S0281KVFRFS|gcore>'

CMD ["ruby", "standup_rollout.rb", "Martin", "Amrou", "Francois", "Ittsel", "Alex", "Guillaume", "Marion"]
