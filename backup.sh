#!/bin/bash
#edit these to your config
#place in folder with docker compose
BWDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
#change working dir
cd ${BWDIR}

FOLDER_NAME=$(basename "$(pwd)")
DATETIME="$(date +'%Y-%m-%d_%H-%M-%S')"
FOLDERPATH="$(date +'%Y-%m-%d')"
#GOOGLEDRIVE will be the name used for rclone config 
GOOGLEDRIVE=""

GZFILE=${FOLDER_NAME}-${DATETIME}.tar.gz

#stop docker
$(docker compose stop)

#change working dir to /tmp
cd /tmp/

# Compress Vaultwarden directory to gzfile
tar -Pczf $GZFILE $BWDIR

# Copy the file to an Rclone storage endpoint
rclone copy $GZFILE ${GOOGLEDRIVE}:/docker_backups/${FOLDERPATH}/

#remove temp file
rm $GZFILE

#change working dir back to docker folder
cd ${BWDIR}

#start docker
$(docker compose up -d)
