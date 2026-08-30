data "azurerm_client_config" "current" {}

resource "azurerm_user_assigned_identity" "aks_uai" {
  name                = "${local.resource_name_prefix}-aks-uai"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = merge(tomap({
    Service = "aks_uai"
  }), local.tags)
}