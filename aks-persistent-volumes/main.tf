terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.55.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "common00" {
  name     = "aks-persistent-volumes-samples-common-00"
  location = "westeurope"
}

resource "azurerm_kubernetes_cluster" "common00" {
  name                = "common00"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.common00.name
  dns_prefix          = "rillion-samples-aks-common00"
  kubernetes_version  = "1.25.5"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_D2_v2"
  }

  network_profile {
    network_plugin = "azure"
  }

  windows_profile {
    admin_username = "aleks"
    admin_password = "swopeiu34trw!poe)iru"
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_kubernetes_cluster_node_pool" "windows00" {
  name                  = "win00"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.common00.id
  vm_size               = "Standard_D2_v2"
  node_count            = 1
  os_type               = "Windows"
  os_sku                = "Windows2022"
  node_labels           = {
    "common2022": "yes"
  }
}

resource "azurerm_storage_account" "common00" {
  name                     = "rillionstwe00"
  resource_group_name      = azurerm_resource_group.common00.name
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_share" "common00" {
  name                 = "common00"
  storage_account_name = azurerm_storage_account.common00.name
  quota                = 50
}

resource "azurerm_storage_share_file" "common00" {
  storage_share_id = azurerm_storage_share.common00.id
  name             = "iisstart.htm"
  source           = "iisstart.htm"
}

resource "azurerm_storage_share" "common01" {
  name                 = "common01"
  storage_account_name = azurerm_storage_account.common00.name
  quota                = 50
}

resource "azurerm_storage_share_file" "common01" {
  storage_share_id = azurerm_storage_share.common01.id
  name             = "iisstart.htm"
  source           = "iisstart.htm"
}

resource "azurerm_storage_share" "common02" {
  name                 = "common02"
  storage_account_name = azurerm_storage_account.common00.name
  quota                = 50
}

resource "azurerm_storage_share" "common03" {
  name                 = "common03"
  storage_account_name = azurerm_storage_account.common00.name
  quota                = 50
}

resource "azurerm_storage_share" "common04" {
  name                 = "common04"
  storage_account_name = azurerm_storage_account.common00.name
  quota                = 50
}

resource "azurerm_storage_share" "common05" {
  name                 = "common05"
  storage_account_name = azurerm_storage_account.common00.name
  quota                = 50
}

resource "azurerm_storage_share" "common06" {
  name                 = "common06"
  storage_account_name = azurerm_storage_account.common00.name
  quota                = 50
}
