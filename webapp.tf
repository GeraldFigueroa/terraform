resource "azurerm_container_registry" "acr" {
  name = "acr${var.project}${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  sku = var.cr_sku
  admin_enabled = true

  tags = var.tags
}

// Backoffice App Service Plan
resource "azurerm_app_service_plan" "back_app_service_plan" {
  name = "sp-back-${var.project}-${var.environment}"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  kind = var.sp_kind
  reserved = true

  sku {
    tier = var.sp_sku_tier
    size = var.sp_sku_size
  }

  tags = var.tags
}

// Web App Service Plan
resource "azurerm_app_service_plan" "web_app_service_plan" {
  name = "sp-web-${var.project}-${var.environment}"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  kind = var.sp_kind
  reserved = true

  sku {
    tier = var.sp_sku_tier
    size = var.sp_sku_size
  }
  
  tags = var.tags
}


// Backoffice Web App UI
resource "azurerm_app_service" "back_ui_webapp" {
  name = "back-ui-${var.project}-${var.environment}"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.back_app_service_plan.id
  
  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/${var.project}/backui:lastest"
    always_on = true
    vnet_route_all_enabled = true
  }
  
  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL" = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
    "WEBSITES_VNET_ROUTE_ALL" = "1"
  }

  depends_on = [
    azurerm_app_service_plan.back_app_service_plan,
    azurerm_container_registry.acr,
    azurerm_subnet.subnetback
    ]
  
  tags = var.tags
}

resource "azurerm_app_service_virtual_network_swift_connection" "back_ui_webapp_vnet_integration" {
  app_service_id = azurerm_app_service.back_ui_webapp.id
  subnet_id = azurerm_subnet.subnetback.id

  depends_on = [
    azurerm_app_service.back_ui_webapp
  ]
}

// Backoffice API Web App
resource "azurerm_app_service" "back_api_webapp" {
  name = "back-api-${var.project}-${var.environment}"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.back_app_service_plan.id
  
  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/${var.project}/backapi:lastest"
    always_on = true
    vnet_route_all_enabled = true
  }
  
  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL" = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
    "WEBSITES_VNET_ROUTE_ALL" = "1"
  }

  depends_on = [
    azurerm_app_service_plan.back_app_service_plan,
    azurerm_container_registry.acr,
    azurerm_subnet.subnetback
    ]
  
  tags = var.tags
}


resource "azurerm_app_service_virtual_network_swift_connection" "back_api_webapp_vnet_integration" {
  app_service_id = azurerm_app_service.back_api_webapp.id
  subnet_id = azurerm_subnet.subnetback.id

  depends_on = [
    azurerm_app_service.back_api_webapp
  ]
}


// Web App UI
resource "azurerm_app_service" "web_ui_webapp" {
  name = "ui-${var.project}-${var.environment}"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.web_app_service_plan.id
  
  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/${var.project}/ui:lastest"
    always_on = true
    vnet_route_all_enabled = true
  }
  
  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL" = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
    "WEBSITES_VNET_ROUTE_ALL" = "1"
  }

  depends_on = [
    azurerm_app_service_plan.web_app_service_plan,
    azurerm_container_registry.acr,
    azurerm_subnet.subnetweb
    ]
  
  tags = var.tags
}

resource "azurerm_app_service_virtual_network_swift_connection" "web_ui_webapp_vnet_integration" {
  app_service_id = azurerm_app_service.web_ui_webapp.id
  subnet_id = azurerm_subnet.subnetweb.id

  depends_on = [
    azurerm_app_service.web_ui_webapp
  ]
}

// API Web App
resource "azurerm_app_service" "web_api_webapp" {
  name = "api-${var.project}-${var.environment}"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.web_app_service_plan.id
  
  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/${var.project}/api:lastest"
    always_on = true
    vnet_route_all_enabled = true
  }
  
  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL" = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
    "WEBSITES_VNET_ROUTE_ALL" = "1"
  }

  depends_on = [
    azurerm_app_service_plan.web_app_service_plan,
    azurerm_container_registry.acr,
    azurerm_subnet.subnetweb
    ]
  
  tags = var.tags
}


resource "azurerm_app_service_virtual_network_swift_connection" "web_api_webapp_vnet_integration" {
  app_service_id = azurerm_app_service.web_api_webapp.id
  subnet_id = azurerm_subnet.subnetweb.id

  depends_on = [
    azurerm_app_service.web_api_webapp
  ]
}