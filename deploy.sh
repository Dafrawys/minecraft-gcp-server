#!/usr/bin/env bash
set -euo pipefail

# ===== LOAD ENV =====
if [ ! -f .env ]; then
  echo ".env file not found. Copy .env.example to .env"
  exit 1
fi

export $(grep -v '^#' .env | xargs)

echo "Project: $PROJECT_ID"

# ===== SET PROJECT =====
gcloud config set project "$PROJECT_ID"

# ===== NETWORK =====
if ! gcloud compute networks describe "$NETWORK" >/dev/null 2>&1; then
  echo "Creating network..."
  gcloud compute networks create "$NETWORK" --subnet-mode=auto
fi

# ===== FIREWALL =====
create_firewall() {
  NAME=$1
  RULES=$2
  TAGS=${3:-}

  if ! gcloud compute firewall-rules describe "$NAME" >/dev/null 2>&1; then
    echo "Creating firewall: $NAME"
    gcloud compute firewall-rules create "$NAME" \
      --network "$NETWORK" \
      --allow "$RULES" \
      ${TAGS:+--target-tags=$TAGS} \
      --source-ranges=0.0.0.0/0
  fi
}

create_firewall allow-ssh tcp:22
create_firewall allow-minecraft tcp:25565 minecraft-server

# ===== STATIC IP =====
if ! gcloud compute addresses describe "$STATIC_IP" --region "$REGION" >/dev/null 2>&1; then
  echo "Creating static IP..."
  gcloud compute addresses create "$STATIC_IP" --region "$REGION"
fi

IP=$(gcloud compute addresses describe "$STATIC_IP" --region "$REGION" --format="value(address)")

# ===== INSTANCE =====
if ! gcloud compute instances describe "$INSTANCE_NAME" --zone "$ZONE" >/dev/null 2>&1; then
  echo "Creating VM..."
  gcloud compute instances create "$INSTANCE_NAME" \
    --zone "$ZONE" \
    --machine-type "$MACHINE_TYPE" \
    --tags minecraft-server \
    --image-family debian-11 \
    --image-project debian-cloud \
    --boot-disk-size "$DISK_SIZE" \
    --boot-disk-type pd-ssd \
    --network "$NETWORK" \
    --address "$IP"
else
  echo "VM already exists"
fi

# ===== STARTUP SCRIPT =====
echo "Configuring Minecraft..."

gcloud compute instances add-metadata "$INSTANCE_NAME" \
  --zone "$ZONE" \
  --metadata=startup-script='#! /bin/bash
apt update -y
apt install -y default-jre-headless wget screen

mkdir -p /opt/minecraft
cd /opt/minecraft

if [ ! -f server.jar ]; then
  wget -q https://launcher.mojang.com/v1/objects/d0d0fe2b1dc6ab4c65554cb734270872b72dadd6/server.jar
fi

echo "eula=true" > eula.txt

screen -dmS minecraft java -Xmx2G -Xms2G -jar server.jar nogui
'

echo "✅ Done!"
echo "Connect: $IP:25565"