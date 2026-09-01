# This module contains per-cluster AKS addon resources.
# It is not part of the blue/green deployment lifecycle, so resources intentionally do not use empty lifecycle ignore_changes blocks.
resource "azurerm_role_assignment" "acr_attach" {
  principal_id                     = var.cluster_kubelet_object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}

# Get node pool rg
data "azurerm_resource_group" "aks_node_rg" {
  name = var.node_resource_group_name
}

# Grant contributor access to AKS node resource group for subscription owners
resource "azurerm_role_assignment" "aks_node_rg_sub_owners" {
  principal_id         = var.sub_owners_objectid
  role_definition_name = "Contributor"
  scope                = data.azurerm_resource_group.aks_node_rg.id

  depends_on = [
    data.azurerm_resource_group.aks_node_rg
  ]
}