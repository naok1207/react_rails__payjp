FROM ruby:3.1.1

ENV TZ=Asia/Tokyo \
    LANG=C.UTF-8 \
    ROOT=/myapp

WORKDIR $ROOT

RUN curl -SL https://deb.nodesource.com/setup_14.x | bash - \
 && apt-get install gcc g++ make \
 && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null \
 && echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update -qq \
 && apt-get install -y nodejs yarn

COPY Gemfile $ROOT
COPY Gemfile.lock $ROOT
COPY package.json $ROOT
COPY yarn.lock $ROOT

RUN bundle install
RUN yarn install
COPY . $ROOT

COPY entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
