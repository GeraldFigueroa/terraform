resource "azurerm_storage_account" "storage_account" {
  name = "storage${var.project}${var.environment}2024"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  account_tier = var.sa_account_tier
  account_replication_type = var.sa_account_replication_type

  tags = var.tags
}


resource "azurerm_storage_container" "blob_file_container" {
  name = "dbfiles"
  storage_account_name = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}


resource "azurerm_private_endpoint" "blob_private_endpoint" {
  name = "blob-private-endpoint-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  subnet_id = azurerm_subnet.subnetblob.id
  
  private_service_connection {
    name = "storage-private-${var.project}-${var.environment}"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names = ["blob"]
    is_manual_connection = false
  }

  tags = var.tags
}


resource "azurerm_private_dns_zone" "sa_private_dns_zone" {
  name = "privatelink.storage.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags
}


resource "azurerm_private_dns_a_record" "sa_private_dns_a_record" {
  name = "storage-record-${var.project}-${var.environment}"
  zone_name = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  
  ttl = 300
  records = [
        azurerm_private_endpoint.blob_private_endpoint.private_service_connection[0].private_ip_address
    ]

  tags = var.tags
}


resource "azurerm_private_dns_zone_virtual_network_link" "sa_vnet_link" {
  name = "sa-vnetlink-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.sa_private_dns_zone.name
  virtual_network_id = azurerm_virtual_network.vnet.id

  tags = var.tags
}