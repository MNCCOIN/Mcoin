
FROM golang:1.9-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /go-mcoin
RUN cd /go-mcoin && make mcoin

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-mcoin/build/bin/mcoin /usr/local/bin/go

EXPOSE 8545 8546 30303 30303/udp 30304/udp
ENTRYPOINT ["mcoin"]
