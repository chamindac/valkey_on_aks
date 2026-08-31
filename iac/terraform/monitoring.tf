# Log analytics workspace for AKS and Application Insights
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.resource_name_prefix}-log"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  retention_in_days   = 30

  tags = merge(tomap({
    Service = "analytics"
  }), local.tags)
}