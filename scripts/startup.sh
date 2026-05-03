#!/bin/bash
set -e

apt update -y
apt install -y default-jre-headless wget screen

mkdir -p /opt/minecraft
cd /opt/minecraft

if [ ! -f server.jar ]; then
  wget -q https://launcher.mojang.com/v1/objects/d0d0fe2b1dc6ab4c65554cb734270872b72dadd6/server.jar
fi

echo "eula=true" > eula.txt

screen -dmS minecraft java -Xmx2G -Xms2G -jar server.jar nogui

(crontab -l 2>/dev/null; echo "*/10 * * * * /opt/minecraft/shutdown.sh") | crontab -