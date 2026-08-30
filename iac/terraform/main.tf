resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_name_prefix}-rg"
  location = var.region

  tags = merge(tomap({
    Service = "resource_group"
  }), local.tags)
}