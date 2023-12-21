FROM golang:1.16-alpine as builder
WORKDIR /build
COPY . .
RUN go mod download
RUN go build -o api ./cmd/api

FROM alpine:3
WORKDIR /app
COPY --from=builder /build/api /app/

EXPOSE 8081
ENTRYPOINT ["./api"]
