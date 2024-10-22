FROM rust:1.80-alpine3.20 as builder
LABEL stage="builder"

ARG APP

RUN apk add --no-cache \
	tzdata \
	ca-certificates \
	git \
	openssh-client \
	musl-dev \
	mold

ENV TZ=UTC

RUN mkdir -p -m 0700 ~/.ssh \
	&& ssh-keyscan github.com >> ~/.ssh/known_hosts \
	&& ssh-keyscan bitbucket.com >> ~/.ssh/known_hosts \
	&& ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts \
	&& ssh-keyscan gitlab.com >> ~/.ssh/known_hosts

RUN git config --global url."git@bitbucket.org:".insteadOf "https://bitbucket.org/"

COPY . /app
WORKDIR /app

RUN --mount=type=ssh cargo build --release -p $APP

FROM alpine:3.20.0

ARG APP

RUN apk add --no-cache \
	tzdata \
	ca-certificates

ENV TZ=UTC

COPY --from=builder /app/target/release/$APP /app/

WORKDIR /app

RUN mv /app/$APP /app/app
RUN addgroup -S usergroup \
	&& adduser -S user -G usergroup
RUN chown -R user:usergroup /home/user/ \
	&& chown user:usergroup /app/app
USER user

ENTRYPOINT [ "/app/app" ]
