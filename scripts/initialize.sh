#!/bin/bash

# copy or create override config of repository
if [ -f ".devcontainer.override/docker-compose.override.yml" ]; then
    cp .devcontainer.override/docker-compose.override.yml .devcontainer/docker-compose.override.yml
else
    :>| .devcontainer/docker-compose.override.yml
fi

# create override config of local if not exists
if [ ! -f ".devcontainer/docker-compose.local.yml" ]; then
    :>| .devcontainer/docker-compose.local.yml
fi
