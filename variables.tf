// General variables
variable "subscription_id" {
  description = "Subscription ID"
  type = string
  sensitive = true
}
variable "project" {
  type = string
  description = "Name of the project"
  default = "contapp"
}
variable "environment" {
  type = string
  description = "Name of the environment to realese"
  default = "dev"
}
variable "location" {
  type = string
  description = "Location of the resources"
  default = "East US 2"
}
variable "tags" {
  description = "Tags to apply to all resources"
  default = {
    environment = "dev"
    project = "contapp"
    created_by = "terraform"
  }
}


// Database variables (db)
variable "db_username" {
  description = "Password for the SQL Server"
  type = string
  sensitive = true
}
variable "db_password" {
  description = "Password for the SQL Server"
  type = string
  sensitive = true
}
variable "db_sqlserver_version" {
  type = string
  description = "Name of the project"
  default = "12.0"
}
variable "db_sku" {
  type = string
  description = "Name of the project"
  default = "S0"
}


// Network variables
variable "myip" {
  description = "IP to allow access to the SQL Server"
  type = string
}


// Storage Account variables (sa)
variable "sa_account_tier" {
  type = string
  description = "Tier of the storage account"
  default = "Standard"
}
variable "sa_account_replication_type" {
  type = string
  description = "Replication type of the storage account"
  default = "LRS"
}


// Container Registry variables (cr)
variable "cr_sku" {
  type = string
  description = "SKU of the Azure Container Registry"
  default = "Basic"
}


// Service Plan variables (sp)
variable "sp_sku_tier" {
  description = "SKU tier of the App Service Plan"
  default = "Standard"
}
variable "sp_sku_size" {
  description = "SKU size of the App Service Plan"
  default = "B1"
}
variable "sp_kind" {
  type = string
  description = "Kind of the App Service Plan (SO)"
  default = "Linux"
}