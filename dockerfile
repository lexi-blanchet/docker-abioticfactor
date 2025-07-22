FROM steamcmd/steamcmd:ubuntu-24

## Install dependencies
RUN dpkg --add-architecture i386 \ 
    && apt update \
    && apt install -y wine64 \
    && apt install -y cabextract winbind screen xvfb

# Create our volumes for stateful data
VOLUME /server

# Set default working directory
WORKDIR /server

# Download Steam app (2857200)
RUN steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir /server \
    +login anonymous \
    +app_update 2857200 \
    validate \
    +quit

# [Server Installation Directory]\AbioticFactor\Saved\SaveGames\Server\Worlds\Cascade


# Expose our default ports
EXPOSE 7777
EXPOSE 27015

# Create abiotic user and grant access to volumes
RUN mkdir /worldsave \
    && useradd -m abiotic -d /home/abiotic \
    && chown -R abiotic:abiotic /server /worldsave \
    && chown -R abiotic:abiotic /usr/bin

# Switch to abiotic user
#USER abiotic

# Setup environment variables defaults that can be overwritten in a compose file
ENV PORT=7777
ENV SERVERNAME=ScienceTeamCentral
ENV SERVERPASSWORD=sciencerules12345
ENV WORLDSAVENAME=scienceteam
ENV MAXPLAYERS=6
ENV QUERYPORT=27015

#Make wine quiet and work
ENV WINEDEBUG=fixme-all
#ENV WINEPREFIX=/home/abiotic/.wine

# Copy server run file
COPY ./scripts/runwineserver.sh /runwineserver.sh

# Entrypoint which starts our server
ENTRYPOINT ["bash", "/runwineserver.sh"]
#ENTRYPOINT ["xvfb-run wine", \
#    "AbioticFactorServer-Win64-Shipping.exe -log -newconsole -useperfthreads -NoAsyncLoadingThread -tcp", \
#    "-QUERYPORT ${QUERYPORT}", \
#    "-PORT ${PORT}", \
#    "-SteamServerName ${SERVERNAME}", \
#    "-ServerPassword ${SERVERPASSWORD}", \
#    "-WorldSaveName ${WORLDSAVENAME}"]
