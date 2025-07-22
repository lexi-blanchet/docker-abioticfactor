#!/bin/bash
# This command line is a nightmare so its just in a shell script for convenience
ServerPassword="${SERVERPASSWORD}"

# If /config is not empty, copy its contents to /server/AbioticFactor
if [ "$(ls -A /config 2>/dev/null)" ]; then
    echo "Copying config files from /config to /server/AbioticFactor/Saved/SaveGames/Server..."
    if [ ! -d "/server/AbioticFactor/Saved/SaveGames/Server" ]; then
        mkdir -p /server/AbioticFactor/Saved/SaveGames/Server
    fi
    cp -r /config/* /server/AbioticFactor/Saved/SaveGames/Server
fi

# Function to handle shutdown
shutdown() {
    echo "Caught SIGTERM, shutting down application..."
    kill -s SIGTERM "$APPLICATION_PID"
    wait "$APPLICATION_PID"
    echo "Application gracefully stopped."
    exit 0
}

# Trap the SIGTERM signal and call the shutdown function
trap 'shutdown' SIGTERM

echo DEBUG: $ServerPassword

# The order is VERY particular and setup is sourced from https://github.com/DFJacob/AbioticFactorDedicatedServer/issues/3#issuecomment-2094369127
xvfb-run wine /server/AbioticFactor/Binaries/Win64/AbioticFactorServer-Win64-Shipping.exe -log -newconsole -useperfthreads -NoAsyncLoadingThread \
    -MaxServerPlayers=${MAXPLAYERS} \
    -PORT=${PORT} -QUERYPORT=${QUERYPORT} \
    -SteamServerName=${SERVERNAME} \
    -WorldSaveName=${WORLDSAVENAME} \
    -ServerPassword=$ServerPassword &
APPLICATION_PID=$!

# Wait for the application to finish (or for the signal to be caught)
wait "$APPLICATION_PID"