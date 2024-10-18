// Servidor de base de datos SQL Server
resource "azurerm_mssql_server" "sqlserver" {
  name = "sqlserver-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  version = var.db_sqlserver_version
  administrator_login = var.db_username
  administrator_login_password = var.db_password

  tags = var.tags
}


resource "azurerm_mssql_database" "sql_db"{
  name = "${var.project}.db"
  server_id = azurerm_mssql_server.sqlserver.id
  sku_name = var.db_sku
  
  tags = var.tags
}


resource "azurerm_private_endpoint" "sql_private_endpoint" {
  name = "sql-private-endpoint-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  subnet_id = azurerm_subnet.subnetdb.id
  
  private_service_connection {
    name = "sql-private-connection-${var.project}-${var.environment}"
    private_connection_resource_id = azurerm_mssql_server.sqlserver.id
    subresource_names = ["sqlServer"]
    is_manual_connection = false
  }

  tags = var.tags
}


resource "azurerm_private_dns_zone" "private_dns_zone" {
  name = "private.dbserver.database.windows.net"
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags
}


resource "azurerm_private_dns_a_record" "private_dns_a_record" {
  name = "sqlserver-record-${var.project}-${var.environment}"
  zone_name = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  
  ttl = 300
  records = [azurerm_private_endpoint.sql_private_endpoint.private_service_connection[0].private_ip_address]

  tags = var.tags
}


resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link" {
  name = "vnetlink-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id = azurerm_virtual_network.vnet.id

  tags = var.tags
}


resource "azurerm_mssql_firewall_rule" "allow_my_ip" {
  name = "allow-my-ip-${var.project}-${var.environment}"
  server_id = azurerm_mssql_server.sqlserver.id
  start_ip_address = var.myip
  end_ip_address = var.myip
}