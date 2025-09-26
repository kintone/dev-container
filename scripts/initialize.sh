#!/bin/bash

if [ -f ".devcontainer.override/docker-compose.override.yml" ]; then
    cp .devcontainer.override/docker-compose.override.yml .devcontainer/docker-compose.override.yml
else
    :>| .devcontainer/docker-compose.override.yml
    echo "Created default docker-compose.override.yml"
fi
