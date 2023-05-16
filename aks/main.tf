variable "ARM_SUBSCRIPTION_ID" {}
variable "ARM_CLIENT_ID" {}
variable "ARM_CLIENT_SECRET" {}
variable "ARM_TENANT_ID" {}

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

resource "azurerm_resource_group" "common00" {
  name     = "aks-samples-common-00"
  location = "westeurope"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "common00"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.common00.name
  dns_prefix          = "tf-samples-aks-common00"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

}