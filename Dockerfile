FROM golang:1-alpine3.14 as base

RUN apk add --no-cache \
	git openssh-client

FROM base as natsBuilder
RUN mkdir -p /go/output
RUN mkdir -p /go/nats
WORKDIR /go/nats
RUN git clone --branch 0.0.26 --depth 1 https://github.com/nats-io/natscli.git . && \
	go build -o /go/output/nats ./nats

FROM base as nkBuilder
RUN mkdir -p /go/nk
WORKDIR /go/nk
RUN git clone --branch v0.3.0 --depth 1 https://github.com/nats-io/nkeys.git . && \
	go build -o /go/output/nk ./nk

FROM alpine:3.14
RUN apk add --no-cache \
	ca-certificates
COPY --from=natsBuilder /go/output/ /usr/local/bin/
COPY --from=nkBuilder /go/output/ /usr/local/bin/
