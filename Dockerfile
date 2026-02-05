FROM golang:1.23-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
ARG TARGETARCH
RUN CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -a -ldflags="-s -w" -o /config-updater .

FROM alpine
COPY --from=builder /config-updater /config-updater
EXPOSE 8436
ENTRYPOINT ["/config-updater"]
