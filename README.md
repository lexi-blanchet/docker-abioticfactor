# About

Abiotic Dedicated server running in wine in ubuntu in docker.

For some reason using bind mounts corrupts save files when you take down the container, so don't do that.

World Save Files are preserved in a volume named `abioticfactor`. On image start if /config has any files it will be copied to `/Server/AbioticFactor/Saved/SaveGames/Server`, this is primarily to copy the `Admin.ini` so you can whitelist your steam ID

# Building

```cmd
docker build -t mber1991/abioticfactor-server .
docker compose up -d
```