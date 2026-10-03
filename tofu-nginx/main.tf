terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "unix:///run/user/1000/podman/podman.sock"
}

module "app" {
  source   = "./modules/app_container"
  for_each = {
    for key, value in var.environments : key => value
    if lookup(value, "enabled", true)
  }

  container_name = "nginx-${each.key}"
  external_port  = each.value.external_port
} 
