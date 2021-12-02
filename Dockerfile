FROM golang:1.15-alpine AS build

RUN apk add --no-cache git

WORKDIR /workspace
ENV GO111MODULE=on

COPY . .

RUN CGO_ENABLED=0 go build -o webhook -ldflags '-w -extldflags "-static"' .

FROM alpine

RUN apk add --no-cache ca-certificates

COPY --from=build /workspace/webhook /usr/local/bin/webhook

ENTRYPOINT ["webhook"]
