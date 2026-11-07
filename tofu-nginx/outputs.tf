output "environments" {
  description = "Deploys summary"
  value = {
    for env, mod in module.app : env => {
      id   = mod.container_id
      url  = mod.nginx_url
      port = mod.external_port
    }
  }
}

output "raw_token" {
  description = "Auth token output"
  value = var.auth_token
  sensitive = true
}
