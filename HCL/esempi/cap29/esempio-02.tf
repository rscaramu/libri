terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-registro-prod"
  location = "italynorth"
}

resource "azurerm_virtual_network" "rete" {
  name                = "vnet-registro"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.20.0.0/16"]
}

resource "azurerm_subnet" "servizi" {
  name                 = "snet-servizi"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.rete.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_storage_account" "documenti" {
  name                     = "stregistrodocumenti"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
