FROM golang:latest AS builder

RUN go get github.com/kiwiirc/webircgateway && \
    cd /go/src/github.com/kiwiirc/webircgateway && \
    CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o webircgateway main.go

FROM scratch 

LABEL maintainer="Jeremy.Bouse@UnderGrid.net"

COPY --from=builder /go/src/github.com/kiwiirc/webircgateway/webircgateway /app/
COPY --from=builder /go/src/github.com/kiwiirc/webircgateway/config.conf.example /app/config.conf

WORKDIR /app

EXPOSE 80 

ENTRYPOINT ["./webircgateway"]
CMD ["-config","config.conf"]