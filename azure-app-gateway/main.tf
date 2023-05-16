variable "ARM_SUBSCRIPTION_ID" {}
variable "ARM_CLIENT_ID" {}
variable "ARM_CLIENT_SECRET" {}
variable "ARM_TENANT_ID" {}
variable "environment" {
  default = "uat"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.83.0"
    }
  }
}

provider "azurerm" {
  subscription_id               = var.ARM_SUBSCRIPTION_ID
  client_id                     = var.ARM_CLIENT_ID
  client_secret                 = var.ARM_CLIENT_SECRET
  tenant_id                     = var.ARM_TENANT_ID
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "eventgrid-to-service-bus-queue-lab-15"
  location = "westeurope"
}

resource "azurerm_public_ip" "appgw_pip" {
  name = "ip_example"
  resource_group_name = azurerm_resource_group.example.name

  location            = "westeurope"
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_application_gateway" "appgw" {
  name                = "example-appgateway"
  resource_group_name = azurerm_resource_group.example.name
  location            = "westeurope"

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = "azurerm_subnet.frontend.id"
  }

  frontend_port {
    name = "port_example"
    port = 443
  }

  frontend_ip_configuration {
    name      = "config_example"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
    disabled_rule_group {
      rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
      rules = [
        "942260"
      ]
    }
  }


  backend_http_settings {
    name                  = "setting_example"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 60
    pick_host_name_from_backend_address = true
  }

  http_listener {
    name                           = "backoffice-listener"
    frontend_ip_configuration_name = "config_example"
    frontend_port_name             = "port_example"
    protocol                       = "Https"
    host_name                      = "local.backoffice_hostname"
  }

  backend_address_pool {
    name  = "backoffice-pool"
    fqdns = [ "local.backoffice_backend_hostname" ] 
  }

  request_routing_rule {
    name                       = "backoffice-rule"
    rule_type                  = "Basic"
    http_listener_name         = "backoffice-listener"
    backend_address_pool_name  = "backoffice-pool"
    backend_http_settings_name = "setting_example"
  }

}