# Stadio 1: compilazione
FROM golang:1.23-alpine AS build
WORKDIR /src
COPY go.mod ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /hello .

# Stadio 2: immagine finale
FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=build /hello /hello
EXPOSE 8080
USER nonroot
ENTRYPOINT ["/hello"]
