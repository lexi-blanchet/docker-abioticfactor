#!/bin/bash
# This command line is a nightmare so its just in a shell script for convenience
ServerPassword="${SERVERPASSWORD}"
# The order is VERY particular and setup is sourced from https://github.com/DFJacob/AbioticFactorDedicatedServer/issues/3#issuecomment-2094369127
xvfb-run wine /server/AbioticFactor/Binaries/Win64/AbioticFactorServer-Win64-Shipping.exe -log -newconsole -useperfthreads -NoAsyncLoadingThread \
    -MaxServerPlayers=${MAXPLAYERS} \
    -PORT=${PORT} -QUERYPORT=${QUERYPORT} \
    -SteamServerName=${SERVERNAME} \
    -WorldSaveName=${WORLDSAVENAME} \
    -ServerPassword=$ServerPassword