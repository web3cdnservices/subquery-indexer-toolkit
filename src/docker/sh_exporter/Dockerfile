FROM golang:1.20.6 as builder

# Create and change to the app directory.
WORKDIR /app

# Retrieve application dependencies.
# This allows the container build to reuse cached dependencies.
# Expecting to copy go.mod and if present go.sum.
COPY go.mod go.sum ./
RUN go mod download

#COPY go.* ./
#RUN go mod download

# Copy local code to the container image.
COPY . ./
RUN ls ./ 
# Build the binary.
RUN go build -v -o server

FROM ubuntu:23.10
RUN set -x && apt-get update && apt-get install -y \
    ca-certificates bash curl bc jq && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/server /app/server

# Run the web service on container startup.
CMD ["/app/server --debug=true"]
