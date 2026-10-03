terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "nginx" {
  name = var.nginx_image
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name = var.container_name

  ports {
    internal = var.internal_port
    external = var.external_port
  }
}
