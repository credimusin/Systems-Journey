terraform {
  required_version = ">= 1.8.0"
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 4.0"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "nginx_conf" {
  content = templatefile("${path.module}/templates/default.conf.tftpl", {
    port = var.internal_port
    env_name = var.env_name
    server_name = var.container_name
  })
  filename = "${path.module}/generated/${var.container_name}.conf"
}

resource "docker_image" "nginx" {
  name = var.nginx_image
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name = var.container_name
  
  env = [
    "CONFIG_SHA256=${local_file.nginx_conf.content_sha256}"
  ]

  ports {
    internal = var.internal_port
    external = var.external_port

  }

  security_opts = ["label=disable"]

  volumes {
    host_path = abspath(local_file.nginx_conf.filename)
    container_path = "/etc/nginx/conf.d/default.conf"
    read_only = true
  }
}
