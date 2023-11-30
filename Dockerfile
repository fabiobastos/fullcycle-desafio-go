FROM golang:1.16-alpine AS build

WORKDIR /app

RUN go mod init app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY main.go .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-s -w" -o main .

FROM scratch

WORKDIR /app

COPY --from=build /app/main .

CMD ["./main"]
