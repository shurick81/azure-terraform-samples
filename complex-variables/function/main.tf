locals {
  merged_app_settings  = merge({
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE"  = true
  }, var.app_settings)
}

resource "azurerm_function_app" "func" {
  name                      = "${var.core_service_name}-${var.name}-${local.environment}-function"
  location                  = local.function_settings.location
  resource_group_name       = local.function_settings.resource_group_name
  app_service_plan_id       = local.function_settings.app_service_plan_id
  storage_connection_string = local.function_settings.storage_connection_string
  version                   = "~4"
  https_only                = true
  
  app_settings = local.merged_app_settings

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["MSDEPLOY_RENAME_LOCKED_FILES"],
      # app_settings["APPINSIGHTS_INSTRUMENTATIONKEY"],
      # tags["hidden-link: /app-insights-conn-string"],
      # tags["hidden-link: /app-insights-instrumentation-key"],
      # tags["hidden-link: /app-insights-resource-id"],
      # site_config["remote_debugging_enabled"],
      # site_config["remote_debugging_version"],
      site_config["scm_type"],
      id,
    ]
  }

  site_config {
    always_on = true
    ftps_state = "Disabled"
    dotnet_framework_version = "v6.0"
    #scm_type = "VSTSRM" 
    #scm_use_main_ip_restriction = true
  }
}


data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault_access_policy" "msi" {
  key_vault_id = local.function_settings.key_vault_id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_function_app.func.identity[0].principal_id

  secret_permissions = [
    "get",
  ]
}