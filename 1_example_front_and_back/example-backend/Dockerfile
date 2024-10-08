# example-backend/Dockerfile

FROM golang:1.16.14-buster

EXPOSE 8080

WORKDIR /go/src/app

COPY . .

RUN go build

CMD ["./server"]