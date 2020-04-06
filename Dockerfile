FROM debian:buster-slim

LABEL maintainer="sytertzp@gmail.com"

ARG PUID=1000

ENV STEAMCMDDIR /home/steam/steamcmd
ENV STEAMAPPID 740
ENV STEAMAPPDIR /home/steam/csgo-dedicated

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
    && mkdir -p ${STEAMAPPDIR}/csgo \
    && cd ${STEAMAPPDIR} \
	&& wget https://raw.githubusercontent.com/duartejbrito/csgo/master/entrypoint.sh \
	&& chmod 755 ${STEAMAPPDIR}/entrypoint.sh \
    && cd ${STEAMAPPDIR}/csgo \
	&& { \
			echo '@ShutdownOnFailedCommand 1'; \
			echo '@NoPromptForPassword 1'; \
			echo 'login anonymous'; \
			echo 'force_install_dir ${STEAMAPPDIR}'; \
			echo 'app_update ${STEAMAPPID}'; \
			echo 'quit'; \
		} > ${STEAMAPPDIR}/csgo_update.txt \
	&& wget -qO- https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz | tar xvzf - \
	&& wget -qO- https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6454-linux.tar.gz | tar xvzf - \
	&& chown -R steam:steam ${STEAMAPPDIR} \
	&& apt-get remove --purge -y \
		wget \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

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
	SRCDS_GAMEMODE=1

USER steam

WORKDIR $STEAMAPPDIR

VOLUME $STEAMCMDDIR
VOLUME $STEAMAPPDIR

ENTRYPOINT ${STEAMAPPDIR}/entrypoint.sh

EXPOSE 27015/tcp 27015/udp 27020/udp
