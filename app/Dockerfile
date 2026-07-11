# ---- Build stage ----
FROM golang:1.22-alpine AS builder

WORKDIR /src

# Cache go modules first for faster rebuilds
COPY go.mod ./
COPY go.sum* ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -ldflags="-s -w" -o /out/hello-world .

# ---- Runtime stage ----
FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /app
COPY --from=builder /out/hello-world .

USER nonroot:nonroot

EXPOSE 8080

ENTRYPOINT ["/app/hello-world"]
