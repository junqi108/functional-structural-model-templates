#!/usr/bin/env bash

###################################################################
# Main
###################################################################

# Git ignore
if [ ! -d ".git" ]; then
   git init
fi

declare -a project_dirs=("documents" "docs" "inputs" "scenarios" "src" "utils" "outputs")

# Create dirs
for i in "${project_dirs[@]}"
do
   if [ ! -d "$i" ]; then
      mkdir -p "$i"
      echo "Created directory: $i"
   fi
done

if [ ! -d templates ]; then
   echo "Creating 'templates' directory"
   git submodule add -f https://github.com/PlantandFoodResearch/functional-structural-model-templates templates
fi

# Gitignore
if [ ! -f .gitignore ]; then
   echo "Adding gitignore to the project"
   cp templates/general/gitignore_general .gitignore
fi

# src
if files=$(ls -qAH -- src) && [ -z "$files" ]; then
   echo "Initialising GroIMP project"
   cp -r templates/src/* src
fi

# Utils
if files=$(ls -qAH -- utils) && [ -z "$files" ]; then
   echo "Initialising utility files"
   cp -r templates/utils/* utils
fi

# outputs
if [ ! -f outputs/.gitignore ]; then
   echo "Adding gitignore to the outputs directory"
   cp templates/general/gitignore_all outputs/.gitignore
fi

# Docs
if [ ! -f docs/index.html ]; then
   echo "Adding index.html to the docs directory"
   cp templates/docs/index.html docs
fi

# README
for i in documents inputs scenarios src utils
do
   if [ ! -f "${i}/README.md" ]; then
      echo "Adding README.md to the ${i} directory"
      cp templates/general/README.md "$i"
   fi
done

# We always want to keep installation docs up-to-date.
# So we overwrite the docs in the current project.
mkdir -p documents/installation
echo "Updating installation documentation"
for i in templates/documents/installation/*
do
   cp "$i" documents/installation
done

# GitHub
if [ ! -d .github ]; then
   echo "Adding GitHub Actions workflows"
   mkdir -p .github
   cp -r templates/github/* .github
fi

# Docker
for i in docker_pull.sh docker-compose.yaml groimp_build.sh groimp_run.sh groimp_headless_run.sh singularity_pull.sh
do
   if [ ! -f "$i" ]; then
      echo "Adding Docker-related file: ${i}"
      cp "templates/docker/${i}" "$i"
   fi
done

if [ ! -f .env ]; then
   echo "Adding .env file"
   cp templates/docker/env_example .env
fi

if [ ! -f services/groimp/Dockerfile ]; then
   echo "Adding Dockerfile"
   mkdir -p services/groimp
   cp templates/docker/Dockerfile services/groimp/Dockerfile
fi

echo "Adding Docker.md documentation file"
cp templates/docker/Docker.md documents/Docker.md

echo Done
