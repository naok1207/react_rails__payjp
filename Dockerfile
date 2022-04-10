FROM ruby:3.1.1-alpine

ENV TZ=Asia/Tokyo \
    LANG=C.UTF-8 \
    ROOT=/myapp

ENV PACKAGES="yarn tzdata imagemagick postgresql-dev gcompat nodejs npm" \
    TEMPORARY_PACKAGES="build-base curl-dev libxml2-dev make gcc libc-dev g++"

WORKDIR $ROOT

RUN apk add --no-cache ${PACKAGES} && \
    apk add --no-cache --virtual build_packs ${TEMPORARY_PACKAGES}

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
RUN apk del build_packs

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
