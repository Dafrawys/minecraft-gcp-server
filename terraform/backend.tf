terraform {
  cloud {
    organization = "Dafrawy-devops"

    workspaces {
      name = "minecraft-server"
    }
  }
}