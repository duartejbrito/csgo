FROM debian:buster-slim

LABEL maintainer="sytertzp@gmail.com"

ARG PUID=1000

ENV STEAMCMDDIR /home/steam/steamcmd

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6=8.3.0-6 \
		lib32gcc1=1:8.3.0-6 \
		wget=1.20.1-1.1 \
		ca-certificates=20190110 \
	&& useradd -u $PUID -m steam \
	&& su steam -c \
		"mkdir -p ${STEAMCMDDIR} \
		&& cd ${STEAMCMDDIR} \
		&& wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf -" \
	&& apt-get remove --purge -y \
		wget \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR $STEAMCMDDIR

VOLUME $STEAMCMDDIR

