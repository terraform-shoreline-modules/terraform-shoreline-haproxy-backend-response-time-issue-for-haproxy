terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "haproxy_backend_response_time_is_above_500ms_for_host" {
  source    = "./modules/haproxy_backend_response_time_is_above_500ms_for_host"

  providers = {
    shoreline = shoreline
  }
}