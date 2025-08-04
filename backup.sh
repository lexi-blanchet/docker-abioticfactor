# https://offen.github.io/docker-volume-backup/reference/
docker run --rm \
  -v abioticfactor:/backup:ro \
  -v ./backup:/archive \
  --entrypoint backup \
  --env-file .env.backup \
  offen/docker-volume-backup:v2