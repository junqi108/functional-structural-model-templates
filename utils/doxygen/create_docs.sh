#!/usr/bin/env bash

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

find . -type f -name "*.rgg" -print0 | xargs -0 sed -i "s/module/class/g"
doxygen

echo; echo "Open $(pwd)/html/index.html"

cd ..
