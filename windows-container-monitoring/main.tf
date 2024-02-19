
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.92.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "common00" {
  name     = "windows-container-monitoring-samples-common-00"
  location = "westeurope"
}

resource "random_password" "aks-windows-admin" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_kubernetes_cluster" "common00" {
  name                = "common00"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.common00.name
  dns_prefix          = "tf-samples-aks-common00"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  network_profile {
    network_plugin = "azure"
  }

  windows_profile {
    admin_username = "aksnodeadmin412323"
    admin_password = random_password.aks-windows-admin.result
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_kubernetes_cluster_node_pool" "windows00" {
  name                  = "win00"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.common00.id
  vm_size               = "Standard_B8ms"
  node_count            = 1
  os_type               = "Windows"
  os_sku                = "Windows2022"
  node_labels           = {
    "common2022": "yes"
  }
}
