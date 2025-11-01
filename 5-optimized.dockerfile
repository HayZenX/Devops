### Multi-stage optimized Dockerfile for the Go app in `go-app/`
#
# Strategy:
# 1) Build a statically-linked, stripped Go binary in a lightweight builder (alpine).
# 2) Copy the binary into a minimal runtime image: `gcr.io/distroless/static:nonroot`.
# 3) Run as a non-root user (distroless `:nonroot` provides a non-privileged user).
#
# This keeps the final image tiny (< 20MB) while preserving functionality.

### Build stage: compile a static, stripped binary
FROM golang:1.21-alpine AS builder
RUN apk add --no-cache git
WORKDIR /src

# Cache modules
COPY go.mod go.sum ./
RUN go mod download

# Copy app sources and build statically
COPY . .
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64
# -s -w strips debug info to reduce binary size
RUN go build -ldflags="-s -w" -o /app ./...


### Final stage: minimal runtime (non-root)
FROM gcr.io/distroless/static:nonroot

# Copy the statically-built binary from the builder
COPY --from=builder /app /app

# Use the nonroot user provided by the distroless image
USER nonroot

# Application runs on port 8080
EXPOSE 8080

ENTRYPOINT ["/app"]

# Notes:
# - This image uses distroless static:nonroot to keep the runtime tiny and enforce non-root.
# - If you prefer `scratch`, you can swap the final stage to `FROM scratch` and then use
#   a numeric USER (e.g. `USER 1000`). Distroless is a bit friendlier for 'non-root' semantics.

