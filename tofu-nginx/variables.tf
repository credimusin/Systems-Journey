variable "nginx_image" {
  description = "Docker image and tag for Nginx"
  type = string
  default = "nginx:alpine"
}

variable "internal_port" {
  description = "Internal port in container"
  type = number
  default = 80
}

variable "environments" {
  description = "Map of env config"
  type = map(object({
    enabled = bool
    external_port = number
  }))
  default = {
    dev = {
      enabled = true
      external_port = 8001
    }
    test = {
      enabled = true
      external_port = 8002
    }
    stage1 = {
      enabled = false
      external_port = 8003
    }
    stage2 = {
      enabled = true
      external_port = 8004
    }
  }
}
