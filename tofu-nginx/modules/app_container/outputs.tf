output "container_id" {
  description = "Container ID"
  value = docker_container.nginx.id
}

output "container_ip" {
  description = "Internal conteiner IP"
  value = docker_container.nginx.network_data[0].ip_address
}

output "external_port" {
  description = "External port on host"
  value = docker_container.nginx.ports[0].external
}

output "nginx_url" {
  description = "Ready URL for check in a browser or via curl"
  value = "http://localhost:${docker_container.nginx.ports[0].external}"
}
