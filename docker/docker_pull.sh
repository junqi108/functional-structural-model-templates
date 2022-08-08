#!/usr/bin/env bash

. .env 

###################################################################
# Main
###################################################################

CONTAINER_REG_NAME="${PWD##*/}"

docker pull "ghcr.io/${CONTAINER_REG_USER}/${CONTAINER_REG_NAME}:latest"
