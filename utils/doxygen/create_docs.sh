#!/usr/bin/env bash

###################################################################
# Functions
###################################################################

replace_module() {
  find . -type f -name "$1" -print0 | xargs -0 sed -i "s/module/class/g"
}

###################################################################
# Main
###################################################################

if [ ! -x "$(command -v doxygen)" ]; then
  echo 'Error: doxygen is not installed.' >&2
  exit 1
fi

if [ ! -x "$(command -v dot)" ]; then
  echo 'Warning: Graphviz is not installed.' >&2
fi
 
[ -d docs ] && rm -rf docs 

mkdir -p docs 
cp -r ../../src/* docs
cp Doxyfile docs
cd docs

replace_module "*.rgg"
replace_module "*.xl"
replace_module "*.java"

doxygen

echo; echo "Open $(pwd)/html/index.html"

cd ..
