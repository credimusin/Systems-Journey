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
