#!/bin/bash
# Creates a script in the directory of your jar file and systemd service for it.
set -e

# Java EXE location
JAVA=$(which java)

usage() {
  echo "Usage: 
  sh systemd4jar.sh YourJavaFile.jar"
}

# Checks
if [ -z "$1" ]; then echo "Jar file??"; usage; exit 1; fi
if [ ! -f "$(realpath $1)" ]; then echo "File $1 not found"; usage; exit 1; fi

# Parameter expansion http://wiki.bash-hackers.org/syntax/pe#common_use
jar_path="$(realpath $1)"     # realpath of Jar file
jar_dir="${jar_path%/*}"      # directory Containing Jar
jar_name="${jar_path##*/}"    # basename with extension
service="${jar_name%.*}"      # basename without ext and versions

# Creating a Bash StartUp Script ----------------------------------------------#
echo "Creating StartUp Script ..."
cat <<EOF > $jar_dir/$service-start.sh
#!/bin/bash
# Start file for 'jar-$service.service'
PKGS=\$(dirname \$(readlink -f "\$0") )
JAR=\$PKGS/$jar_name

# Change following is required
JAVA_PATH=\$(dirname \$(which java))
LOG=\$PKGS/$service.log 

\$JAVA_PATH/java -jar \$JAR /tmp | tee -a \$LOG  
EOF
chmod +x $jar_dir/$service-start.sh
cat $jar_dir/$service-start.sh  

# Creating a systemd service --------------------------------------------------#
echo "Creating Service ..."
cat <<EOF >/etc/systemd/system/jar-$service.service
[Unit]
Description=JAR Service $jar_name 
[Service]
ExecStart=$jar_dir/$service-start.sh
SuccessExitStatus=143
TimeoutStopSec=10
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOF
cat /etc/systemd/system/jar-$service.service

systemctl daemon-reload

echo "
===============================[Service Created]================================
Created : jar-$service
JarFile : $jar_name
Script  : $service-start.sh
Location: $jar_dir 
|--------------------------------- USAGE --------------------------------------|
to start: 
  systemctl start jar-$service   
Check logs:         
  sudo journalctl -f -n 100 -u jar-$service
Optional to enable auto startup on boot:
  systemctl enable jar-$service
================================================================================
"
