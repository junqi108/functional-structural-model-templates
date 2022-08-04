#!/usr/bin/env bash

###################################################################
# Main
###################################################################

if [ ! -d ".git" ]; then
   git init
fi

declare -a project_dirs=("documents" "docs" "inputs" "scenarios" "src" "utils" "outputs")

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

if files=$(ls -qAH -- src) && [ -z "$files" ]; then
   echo "Initialising GroIMP project"
   cp -r templates/src/* src
fi

if files=$(ls -qAH -- utils) && [ -z "$files" ]; then
   echo "Initialising utility files"
   cp -r templates/utils/* utils
fi

if [ ! -f outputs/.gitignore ]; then
   echo "Adding gitignore to the outputs directory"
   cp templates/general/gitignore outputs/.gitignore
fi

if [ ! -f docs/index.html ]; then
   echo "Adding index.html to the docs directory"
   cp templates/docs/index.html docs
fi

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

if [ ! -d .github ]; then
   echo "Adding GitHub Actions workflows"
   mkdir -p .github
   cp -r templates/github/* .github
fi

echo Done
