#!/bin/bash
# Creates a script in the directory of your jar file and systemd service for it.

usage() {
  echo "Usage: 
  sh systemd4jar.sh YourJavaFile.jar"
}

# Checks
if [ -z "$1" ]; then echo "Jar file??"; usage; exit 1; fi
if [ ! -f "$(realpath $1)" ]; then echo "File $1 not found"; usage; exit 1; fi

jar_loc="$(realpath $1)"
jar_dir="${jar_loc%/*}"
jar_nam="${jar_loc##*/}"
jar_ser="${jar_nam}"
echo "full : $jar_loc"
echo "path : $jar_dir"
echo "base : ${jar_loc##*/}"
echo "ext  : ${jar_loc##*.}"
echo "Test": ${`${jar_loc##*/}`%.*}


echo "Creating StartUp Script ..."
#cat <<EOF > $(dirname $jar_file)/service4jar.sh