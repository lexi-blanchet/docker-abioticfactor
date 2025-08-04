#!/bin/bash
# This command line is a nightmare so its just in a shell script for convenience
ServerPassword="${SERVERPASSWORD}"

# If Admin.ini exists, we copy it.
if [ -e "/config/Admin.ini" ]; then
    echo "Copying Admin.ini from /config to /server/AbioticFactor/Saved/SaveGames/Server..."
    if [ ! -d "/server/AbioticFactor/Saved/SaveGames/Server" ]; then
        mkdir -p /server/AbioticFactor/Saved/SaveGames/Server
    fi
    cp /config/Admin.ini /server/AbioticFactor/Saved/SaveGames/Server
fi

# If SandboxSettings.ini exists and a world save exists already, we copy it
if [ -e "/config/SandboxSettings.ini" ]; then
    echo "SandboxSettings.ini exists, attempting to copy."
    if [ -d "/server/AbioticFactor/Saved/SaveGames/Server/Worlds/${WORLDSAVENAME}" ]; then
        echo "Copying SandboxSettings.ini to /server/AbioticFactor/Saved/SaveGames/Server/Worlds/${WORLDSAVENAME}"
        cp /config/SandboxSettings.ini /server/AbioticFactor/Saved/SaveGames/Server/Worlds/${WORLDSAVENAME}
    else 
        echo "WorldSave does not exist yet, wait for at least one save to generate then restart this image to copy SandboxSettings.ini"
    fi
fi

# Copy pak mods because they're easy
if [ -d "/mods" ]; then
    echo "/mods folder is mounted, copying."
    cp /mods/* /server/AbioticFactor/Content/Paks/
fi

# The order is VERY particular and setup is sourced from https://github.com/DFJacob/AbioticFactorDedicatedServer/issues/3#issuecomment-2094369127
xvfb-run -a wine /server/AbioticFactor/Binaries/Win64/AbioticFactorServer-Win64-Shipping.exe -log -newconsole -useperfthreads -NoAsyncLoadingThread \
    -MaxServerPlayers=${MAXPLAYERS} \
    -PORT=${PORT} -QUERYPORT=${QUERYPORT} \
    -SteamServerName=${SERVERNAME} \
    -WorldSaveName=${WORLDSAVENAME} \
    -ServerPassword=$ServerPassword &
APPLICATION_PID=$!

# Function to handle shutdown
shutdown() {
    echo "Caught SIGTERM, shutting down application..."
    kill -"$1" $(pgrep -P $APPLICATION_PID)
    wait $APPLICATION_PID
    echo "Application gracefully stopped."
    exit 0
}

# Trap the SIGTERM signal and call the shutdown function
trap 'shutdown SIGTERM' SIGTERM

# Wait for the application to finish (or for the signal to be caught)
wait $APPLICATION_PID