#!/bin/bash
# Creates a script in the directory of your jar file and systemd service for it.

usage() {
  echo "Usage: 
  sh systemd4jar.sh YourJavaFile.jar"
}

# Checks
if [ -z "$1" ]; then echo "Jar file??"; usage; exit 1; fi
if [ ! -f "$(realpath $1)" ]; then echo "File $1 not found"; usage; exit 1; fi

jar_file="$(realpath $1)"
echo "full : $jar_file"
echo "path : ${jar_file%/*}"
echo "base : ${jar_file##*/}"
echo "ext  : ${jar_file##*.}"
echo $(basename $jar_file)

echo "Creating StartUp Script ..."
#cat <<EOF > $(dirname $jar_file)/service4jar.sh