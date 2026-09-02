data "azurerm_virtual_network" "env_vnet" {
  name                = "${var.prefix}-${var.environment}-${var.region_short_code}-vnet"
  resource_group_name = "${var.prefix}-${var.environment}-vnet-rg"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${local.resource_name_prefix}-aks-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = merge(tomap({
    Service              = "network security group"
    SystemClassification = local.tags.SystemClassification
  }), local.tags)
}

# AKS Node Subnet
resource "azurerm_subnet" "aks_node_snet" {
  name                              = "${local.resource_name_prefix}-aks-node-snet"
  resource_group_name               = data.azurerm_virtual_network.env_vnet.resource_group_name
  virtual_network_name              = data.azurerm_virtual_network.env_vnet.name
  address_prefixes                  = ["${var.aks_node_subnet_cidr}"]
  private_endpoint_network_policies = "Enabled"
  default_outbound_access_enabled   = true
}

# AKS Pod Subnet
resource "azurerm_subnet" "aks_pod_snet" {
  name                              = "${local.resource_name_prefix}-aks-pod-snet"
  resource_group_name               = data.azurerm_virtual_network.env_vnet.resource_group_name
  virtual_network_name              = data.azurerm_virtual_network.env_vnet.name
  address_prefixes                  = ["${var.aks_pod_subnet_cidr}"]
  private_endpoint_network_policies = "Enabled"
  default_outbound_access_enabled   = true

  delegation {
    name = "aks-delegation"

    service_delegation {
      name    = "Microsoft.ContainerService/managedClusters"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# Assign user assigned id of aks to aksnode subnet
resource "azurerm_role_assignment" "aks_uai_aks_node_snet" {
  principal_id         = azurerm_user_assigned_identity.aks_uai.principal_id
  role_definition_name = "Network Contributor"
  scope                = azurerm_subnet.aks_node_snet.id
}

# Assign user assigned id of aks to aks pod subnet
resource "azurerm_role_assignment" "aks_uai_aks_pod_snet" {
  principal_id         = azurerm_user_assigned_identity.aks_uai.principal_id
  role_definition_name = "Network Contributor"
  scope                = azurerm_subnet.aks_pod_snet.id
}

# Associate AKS node subnet with network security group
resource "azurerm_subnet_network_security_group_association" "aks_node_snet_nsg" {
  subnet_id                 = azurerm_subnet.aks_node_snet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Associate AKS pod subnet with network security group
resource "azurerm_subnet_network_security_group_association" "aks_pod_snet_nsg" {
  subnet_id                 = azurerm_subnet.aks_pod_snet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}