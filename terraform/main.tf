provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "mc_network" {
  name = "mc-network"
}

resource "google_compute_firewall" "minecraft" {
  name    = "allow-minecraft"
  network = google_compute_network.mc_network.name

  allow {
    protocol = "tcp"
    ports    = ["25565"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["minecraft-server"]
}

resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = google_compute_network.mc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "static_ip" {
  name   = "mc-server-ip"
  region = var.region
}

resource "google_compute_instance" "minecraft" {
  name         = "mc-server"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["minecraft-server"]
  
  metadata = {
    enable-oslogin = "TRUE"
   }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 50
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = google_compute_network.mc_network.name

    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y default-jre-headless wget screen

    mkdir -p /opt/minecraft
    cd /opt/minecraft

    wget -q https://launcher.mojang.com/v1/objects/d0d0fe2b1dc6ab4c65554cb734270872b72dadd6/server.jar

    echo "eula=true" > eula.txt

    screen -dmS minecraft java -Xmx2G -Xms2G -jar server.jar nogui
  EOF
}