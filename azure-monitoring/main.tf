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
  name     = "azure-monitoring-common-00"
  location = "westeurope"
}

resource "azurerm_log_analytics_workspace" "common00" {
  name                = "common00"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.common00.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_resource_group" "app00" {
  name     = "azure-monitoring-app-00"
  location = "westeurope"
}

resource "azurerm_application_insights" "app00" {
  name                = "app00"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.app00.name
  workspace_id        = azurerm_log_analytics_workspace.common00.id
  application_type    = "web"
}

resource "azurerm_resource_group" "app01" {
  name     = "azure-monitoring-app-01"
  location = "westeurope"
}

resource "azurerm_application_insights" "app01" {
  name                = "app01"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.app01.name
  workspace_id        = azurerm_log_analytics_workspace.common00.id
  application_type    = "web"
}

resource "azurerm_resource_group" "app02" {
  name     = "azure-monitoring-app-02"
  location = "westeurope"
}

resource "azurerm_application_insights" "app02" {
  name                = "app02"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.app02.name
  workspace_id        = azurerm_log_analytics_workspace.common00.id
  application_type    = "web"
}

resource "azurerm_resource_group" "app03" {
  name     = "azure-monitoring-app-03"
  location = "westeurope"
}

resource "azurerm_application_insights" "app03" {
  name                = "app03"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.app03.name
  workspace_id        = azurerm_log_analytics_workspace.common00.id
  application_type    = "web"
}
