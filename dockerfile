FROM steamcmd/steamcmd:ubuntu-24 AS build

# Create our server directory
RUN mkdir /server

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

FROM ubuntu:latest

# Install dependencies
RUN dpkg --add-architecture i386 \ 
    &&apt update \
    && apt install -y wine32 wine64 \
    && apt install -y xvfb \
    # Clean cache
    && apt -y clean autoclean \
    && apt -y autoremove \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /server /server

# Expose our default ports
EXPOSE 7777
EXPOSE 27015

# Setup environment variables defaults that can be overwritten in a compose file
ENV PORT=7777
ENV SERVERNAME=ScienceTeamCentral
ENV SERVERPASSWORD=sciencerules12345
ENV WORLDSAVENAME=Cascade
ENV MAXPLAYERS=6
ENV QUERYPORT=27015

#Make wine quiet and work
ENV WINEDEBUG=fixme-all

# Copy server run file
COPY ./scripts/runwineserver.sh /runwineserver.sh

# Entrypoint which starts our server
ENTRYPOINT ["bash", "/runwineserver.sh"]
