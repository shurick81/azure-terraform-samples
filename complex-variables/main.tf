variable "ARM_SUBSCRIPTION_ID" {}
variable "ARM_CLIENT_ID" {}
variable "ARM_CLIENT_SECRET" {}
variable "ARM_TENANT_ID" {}
variable "environment" {
  default = "uat"
}

locals {
  premium_service_bus_sku = contains(["prod", "qa"], var.environment)
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

resource "azurerm_servicebus_namespace" "example" {
  name                = var.azure_product_feed.dev
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = local.premium_service_bus_sku ? "Premium" : "Standard"
  zone_redundant      = true
  capacity            = 1
}
