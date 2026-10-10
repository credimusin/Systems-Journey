terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }

  backend "s3" {
    bucket                      = "tofu-state"
    key                         = "dev/teraform.tfstate"
    region                      = "us-east-1"
    endpoints                   = {
                                  s3 = "http://localhost:9000"
                                }

    access_key                  = "minioadmin"
    secret_key                  = "minioadmin"

    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true

    use_path_style              = true
    use_lockfile                = true
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
