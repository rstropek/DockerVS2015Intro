# Use a multi-stage build
FROM golang:latest AS builder

# Compile Go into exe
WORKDIR /app
COPY . .
# Note that linker flags -s -w: Omits symbol table and debug information
# Read more about compile flags at https://golang.org/cmd/go/#hdr-Compile_packages_and_dependencies
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -a -o ./api .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
EXPOSE 8080

# Copy exe from build container
COPY --from=builder /app/api ./
RUN chmod +x ./api

# Define start command
CMD ["./api", "80"]