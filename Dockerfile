FROM mono:latest

ARG VERSION
ENV PORT=7144
ENV RTMP_PORT=1935

WORKDIR /usr/app/peercaststation

RUN apt-get update \
 && apt-get install -y curl unzip \
 && curl -o /tmp/peca.zip http://www.pecastation.org/files/PeerCastStation-${VERSION}.zip \
 && unzip /tmp/peca.zip -d /tmp/ \
 && mv /tmp/PeerCastStation-${VERSION}/* /usr/app/peercaststation/ \
 && apt-get remove -y curl unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/*

EXPOSE ${PORT}
EXPOSE ${RTMP_PORT}

ENTRYPOINT ["mono", "PeerCastStation.exe"]
