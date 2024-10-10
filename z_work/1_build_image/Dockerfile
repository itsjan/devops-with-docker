FROM alpine:latest

WORKDIR /usr/src/app

COPY hello.sh .

# inside the image:
RUN touch additional.txt

CMD ./hello.sh
