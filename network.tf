// Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name = "vnet-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  address_space = ["10.0.0.0/16"]

  tags = var.tags
}

// Subnet for the database
resource "azurerm_subnet" "subnetdb" {
  name = "subnet-db-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.1.0/24"]
}

// Surbnet for the storage account
resource "azurerm_subnet" "subnetblob" {
  name = "subnet-blob-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.2.0/24"]
}

// Subnet for backoffice
resource "azurerm_subnet" "subnetback" {
  name = "subnet-back-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.3.0/24"]

  delegation {
    name = "back_webapp_delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

// Subnet for Web App
resource "azurerm_subnet" "subnetweb" {
  name = "subnet-web-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.4.0/24"]

  delegation {
    name = "webapp_delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}
