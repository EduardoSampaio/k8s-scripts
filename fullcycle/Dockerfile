# Etapa 1: build
FROM golang:1.24 AS build
WORKDIR /app

COPY go.mod .
COPY server.go .

# Compilação estática para rodar no Alpine
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server .

# Etapa 2: runtime minimalista
FROM alpine:latest
WORKDIR /app
COPY --from=build /app/server .

EXPOSE 80
CMD ["./server"]
