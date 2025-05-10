FROM golang:1.24.3 as builder

WORKDIR /app
COPY . .

RUN go mod tidy & go build -o stream-service

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/stream-service .
COPY --from=builder /app/proto ./proto

EXPOSE 3011

CMD ["./stream-service"]