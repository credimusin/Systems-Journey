variable "container_name" {
  description = "The name for Podman container"
  type = string
}

variable "nginx_image" {
  description = "Docker image and tag for Nginx"
  type = string
  default = "nginx:alpine"
}

variable "external_port" {
  description = "External port on host"
  type = number
}

variable "internal_port" {
  description = "Internal port in container"
  type = number
  default = 80
}
