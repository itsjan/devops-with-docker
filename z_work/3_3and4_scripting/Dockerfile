FROM docker

WORKDIR /usr/local/bin

COPY ./builder.sh /usr/local/bin/builder.sh
RUN chmod +x /usr/local/bin/builder.sh

ENTRYPOINT [ "sh", "builder.sh" ]

