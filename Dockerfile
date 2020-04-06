FROM debian:buster-slim

LABEL maintainer="sytertzp@gmail.com"

ARG PUID=1000

ENV STEAMDIR=/home/steam \
    STEAMCMDDIR=/home/steam/steamcmd \
    STEAMAPPDIR=/home/steam/csgo-dedicated \
    STEAMAPPID=740

RUN set -x \
    && useradd -u $PUID -m steam \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        lib32stdc++6=8.3.0-6 \
        lib32gcc1=1:8.3.0-6 \
        wget=1.20.1-1.1 \
        ca-certificates=20190110 \
        lib32z1 \
    && su steam -c \
        "mkdir -p ${STEAMCMDDIR} \
        && cd ${STEAMCMDDIR} \
        && wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf -" \
    && mkdir -p ${STEAMDIR}/.steam/sdk32 \
    && ln -s ${STEAMCMDDIR}/linux32/steamclient.so ${STEAMDIR}/.steam/sdk32/steamclient.so \
    && mkdir -p ${STEAMDIR} \
    && cd ${STEAMDIR} \
    && wget https://raw.githubusercontent.com/duartejbrito/csgo/master/root/entrypoint.sh \
    && chmod 755 ${STEAMDIR}/entrypoint.sh 

ENV SRCDS_FPSMAX=300 \
    SRCDS_TICKRATE=128 \
    SRCDS_PORT=27015 \
    SRCDS_TV_PORT=27020 \
    SRCDS_CLIENT_PORT=27005 \
    SRCDS_MAXPLAYERS=14 \
    SRCDS_TOKEN=0 \
    SRCDS_RCONPW="changeme" \
    SRCDS_PW="changeme" \
    SRCDS_STARTMAP="de_dust2" \
    SRCDS_REGION=3 \
    SRCDS_MAPGROUP="mg_active" \
    SRCDS_GAMETYPE=0 \
    SRCDS_GAMEMODE=1 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

USER steam

WORKDIR $STEAMCMDDIR

VOLUME $STEAMAPPDIR

ENTRYPOINT ${STEAMDIR}/entrypoint.sh

EXPOSE 27015/tcp 27015/udp 27020/udp
