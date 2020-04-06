  
#!/bin/bash

set -x \
&& mkdir -p ${STEAMAPPDIR}/csgo \
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
&& wget -qO- https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6454-linux.tar.gz | tar xvzf - 

${STEAMCMDDIR}/steamcmd.sh +login anonymous +force_install_dir ${STEAMAPPDIR} +app_update ${STEAMAPPID} +quit

${STEAMAPPDIR}/srcds_run -game csgo -console -autoupdate -steam_dir ${STEAMCMDDIR} -steamcmd_script ${STEAMAPPDIR}/csgo_update.txt -usercon +fps_max $SRCDS_FPSMAX \
	-tickrate $SRCDS_TICKRATE -port $SRCDS_PORT +tv_port $SRCDS_TV_PORT +clientport $SRCDS_CLIENT_PORT -maxplayers_override $SRCDS_MAXPLAYERS +game_type $SRCDS_GAMETYPE +game_mode $SRCDS_GAMEMODE \
	+mapgroup $SRCDS_MAPGROUP +map $SRCDS_STARTMAP +sv_setsteamaccount $SRCDS_TOKEN +rcon_password $SRCDS_RCONPW +sv_password $SRCDS_PW +sv_region $SRCDS_REGION