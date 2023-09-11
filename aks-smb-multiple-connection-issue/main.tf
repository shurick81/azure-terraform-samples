terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.55.0"
    }
    time = {
      version = "~> 0.9.1"
    }
  }
}

provider "azurerm" {
  subscription_id = "a8549e6e-fbc2-4ab2-b2c0-6fd39f8e6ffe"
  features {}
}

provider "azurerm" {
  alias = "sub01"
  subscription_id = "cadd2afa-f090-4f25-9e5b-b0e15095d582"
  features {}
}

resource "azurerm_resource_group" "sub00common00" {
  name     = "aks-smb-multiple-connection-issue-common-00"
  location = "westeurope"
}

resource "random_password" "win_pass" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_kubernetes_cluster" "common00" {
  name                = "common00"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.sub00common00.name
  node_resource_group = "aks-smb-multiple-connection-issue-common-01"
  dns_prefix          = "rillion-samples-aks-common00"
  kubernetes_version  = "1.25.11"

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
    admin_password = random_password.win_pass.result
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_kubernetes_cluster_node_pool" "windows00" {
  name                  = "win00"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.common00.id
  vm_size               = "Standard_B8ms"
  node_count            = 6
  os_type               = "Windows"
  os_sku                = "Windows2022"
  node_labels           = {
    "common2022": "yes"
  }
}

resource "azurerm_resource_group" "sub01common00" {
  provider = azurerm.sub01
  name     = "aks-smb-multiple-connection-issue-common-00"
  location = "westeurope"
}

resource "azurerm_storage_account" "common00" {
  count                    = 50
  provider                 = azurerm.sub01
  name                     = "rillioninstwe${count.index}"
  resource_group_name      = azurerm_resource_group.sub01common00.name
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_share" "common00" {
  count                = 50
  provider             = azurerm.sub01
  name                 = "common00"
  storage_account_name = azurerm_storage_account.common00[count.index].name
  quota                = 50
}

resource "azurerm_storage_share_directory" "directory00" {
  count                = 50
  provider             = azurerm.sub01
  name                 = "directory00"
  share_name           = azurerm_storage_share.common00[count.index].name
  storage_account_name = azurerm_storage_account.common00[count.index].name
}

resource "azurerm_storage_share_file" "common00" {
  count            = 50
  provider         = azurerm.sub01
  storage_share_id = azurerm_storage_share.common00[count.index].id
  path             = "directory00"
  name             = "iisstart.htm"
  source           = "iisstart.htm"
  depends_on      = [azurerm_storage_share_directory.directory00]
}

resource "azurerm_storage_share_directory" "directory01" {
  count                = 50
  provider             = azurerm.sub01
  name                 = "directory01"
  share_name           = azurerm_storage_share.common00[count.index].name
  storage_account_name = azurerm_storage_account.common00[count.index].name
}

resource "azurerm_storage_share_directory" "directory02" {
  count                = 50
  provider             = azurerm.sub01
  name                 = "directory02"
  share_name           = azurerm_storage_share.common00[count.index].name
  storage_account_name = azurerm_storage_account.common00[count.index].name
}

resource "azurerm_storage_share_directory" "directory03" {
  count                = 50
  provider             = azurerm.sub01
  name                 = "directory03"
  share_name           = azurerm_storage_share.common00[count.index].name
  storage_account_name = azurerm_storage_account.common00[count.index].name
}

resource "azurerm_storage_share_directory" "directory04" {
  count                = 50
  provider             = azurerm.sub01
  name                 = "directory04"
  share_name           = azurerm_storage_share.common00[count.index].name
  storage_account_name = azurerm_storage_account.common00[count.index].name
}

resource "azurerm_storage_share_directory" "directory05" {
  count                = 50
  provider             = azurerm.sub01
  name                 = "directory05"
  share_name           = azurerm_storage_share.common00[count.index].name
  storage_account_name = azurerm_storage_account.common00[count.index].name
}

resource "azurerm_storage_share" "common01" {
  count                = 50
  provider             = azurerm.sub01
  name                 = "common01"
  storage_account_name = azurerm_storage_account.common00[count.index].name
  quota                = 50
}

resource "azurerm_storage_share" "common02" {
  count                = 50
  provider             = azurerm.sub01
  name                 = "common02"
  storage_account_name = azurerm_storage_account.common00[count.index].name
  quota                = 50
}
