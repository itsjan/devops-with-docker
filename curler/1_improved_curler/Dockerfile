FROM ubuntu:22.04

RUN	apt-get update; \
	apt-get install -y curl
WORKDIR /usr/local/bin
COPY ./script.sh .

ENTRYPOINT ["./script.sh"]
