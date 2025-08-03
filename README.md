# About

Abiotic Factor (AF) Dedicated server running in wine in ubuntu in docker.


⚠️ **SAVE FILE CORRUPTION DANGER**:
For some reason using bind mounts corrupts save files when you take down the container at time of writing. Stick to regular named docker volumes and back them up.

This is default behavior if using the example docker-compose

# Build and Run

I don't push this image anywhere because it's quite large after building ~6.4 GB so you'll need to build this yourself.

```cmd
docker compose build
docker commpose up -d
```

## Updating

There is no built-in mechanism for detecting an AF update right now. You will need to manually re-run the above build command

## Save Files

📝 **World Save Folder Structure**: If starting from scratch with no existing save file the folder `\AbioticFactor\Saved\SaveGames\Server\Worlds\` will not yet exist. This folder structure will be generated upon first autosave or by doing an admin force save.

📝 **World Save States**: This server does *not* auto-save on docker shutdown, either force one in the admin console or make sure someone has logged out recently.

### Save Structure

World Save Files are preserved in a docker image volume named `/server`. 
If using the default `docker-compose.yml` file this will be automatically mounted to a named docker volume named `abioticfactor` that should persist between image states.

You should backup this volume regularly as AF has a known bug where your save becomes corrupted. The backup system built into the program is very rudimentary.

# Configuration

## Abiotic Factor Server Configuration Files

In /config rename the files to not have `.example` at the end and they will be uploaded into your server on container start. If no save file exists yet you will need to wait until you hit an autosave then restart the container.

## Mod Installation

This docker compose file supports installing basic mods that involve just copying .pak files into the correct folder. (Ex: https://www.nexusmods.com/abioticfactor/mods/65?tab=posts)

To enable this functionality unzip all the files in the zip file you downloaded into a folder named "mods" and it will be copied into the correct location when the server is brought up.