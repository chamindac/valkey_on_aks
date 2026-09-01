# Private dns zone for AKS
resource "azurerm_private_dns_zone" "aks_dns_zone" {
  name                = "${local.instance_name}.net"
  resource_group_name = azurerm_resource_group.rg.name

  tags = merge(tomap({
    Service = "private dns"
  }), local.tags)
}

resource "azurerm_role_assignment" "aks_dns_zone_sub_owners" {
  scope                = azurerm_private_dns_zone.aks_dns_zone.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_group.sub_owners.object_id
}

# Private dns a record for AKS vnet Nginx-Gateway Private IP
resource "azurerm_private_dns_a_record" "aks_vnet_nginx" {
  name                = "*.${local.aks_vnet_dns_prefix}"
  private_dns_zone_id = azurerm_private_dns_zone.aks_dns_zone.id
  ttl                 = 3600
  records             = [var.sh_private_ip_nginx_gateway_vnet]
}

# Private dns a record for AKS vnet Valkey bootstrap internal LB Private IP
resource "azurerm_private_dns_a_record" "aks_vnet_valkey" {
  name                = "${local.valkey_route_prefix}.${local.aks_vnet_dns_prefix}"
  private_dns_zone_id = azurerm_private_dns_zone.aks_dns_zone.id
  ttl                 = 3600
  records             = [var.sh_private_ip_valkey]
}