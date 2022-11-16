#!/usr/bin/env bash

###################################################################
# Main
###################################################################

# Git ignore
if [ ! -d ".git" ]; then
   git init
fi

declare -a project_dirs=("documents" "docs" "inputs" "experiments" "treatments" "src" "utils" "outputs")

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
   git submodule add -f https://github.com/junqi108/functional-structural-model-templates templates
else
   echo "Updating 'templates' directory"
   cd templates && git pull origin main && cd ..
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

if [ -d src/shared ]; then
   rm -rf src/shared
fi

echo "Updating files in src/shared directory"
mkdir -p src/shared
cp -r templates/src/shared/* src/shared

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
for i in documents inputs experiments treatments src utils
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
for i in docker-compose.yaml docker_build.sh singularity_pull.sh
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

echo "Adding Docker.md documentation file"
cp templates/docker/Docker.md documents/Docker.md

# GroIMP
echo "Adding GroIMP extensions"
mkdir -p ext
cp -r templates/ext/* ext

echo Done

cp templates/general/init_project.sh init_project.sh 
