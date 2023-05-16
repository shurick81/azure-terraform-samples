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

resource "azurerm_resource_group" "example" {
  name     = "eventgrid-to-service-bus-queue-lab-00"
  location = "westeurope"
}

resource "azurerm_virtual_network" "example" {
  name                = "vnet00"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.131.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.131.0.0/24"]
  service_endpoints    = ["Microsoft.AzureCosmosDB", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Web", "Microsoft.ContainerRegistry", "Microsoft.EventHub"]
}

resource "azurerm_subnet" "vms" {
  name                 = "VirtualMachines"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.131.4.0/24"]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Web"]
}

resource "azurerm_servicebus_namespace" "example" {
  name                = "eventgrid-to-service-bus-queue-lab-00"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
  zone_redundant      = false
  capacity            = 0
}

resource "azurerm_servicebus_queue" "example" {
  name                = "queue00"
  namespace_name      = azurerm_servicebus_namespace.example.name
  resource_group_name = azurerm_resource_group.example.name

  enable_partitioning = false
}

resource "azurerm_eventgrid_topic" "example" {
  name                = "topic-eventgrid-to-service-bus-queue-lab-00"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  public_network_access_enabled = true
}

resource "azurerm_eventgrid_event_subscription" "example" {
  name  = "subscription00"
  scope = azurerm_eventgrid_topic.example.id

  service_bus_queue_endpoint_id = azurerm_servicebus_queue.example.id  

  advanced_filter {
    string_begins_with {
     key    = "subject"
     values = ["Test_Ventilak_Order_Created"]
    }
  }
}
