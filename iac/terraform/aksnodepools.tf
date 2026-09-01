module "aks_vnet_nodepool_blue" {
  count = var.sys_sh_is_blue_deployed ? 1 : 0

  # DO NOT change below module source and the comment --> source = "./modules/aksnodepools" # Blue
  source = "./modules/aksnodepools" # Blue

  deployment_name    = local.deployment_name_blue
  kubernetes_version = local.kubernetes_version
  aks_cluster_id     = azurerm_kubernetes_cluster.aks_vnet.id
  system_vm_size     = local.sh_aks_system_vm_size
  service_vm_size    = local.sh_aks_valkey_vm_size
  node_subnet_id     = azurerm_subnet.aks_node_snet.id
  pod_subnet_id      = azurerm_subnet.aks_pod_snet.id

  max_pods               = local.sh_aks_vnet_max_pods
  service_node_count     = local.sh_valkey_nodepool.node_count
  service_min_node_count = local.sh_valkey_nodepool.min_node_count
  service_max_node_count = local.sh_valkey_nodepool.max_node_count

  depends_on = [
    azurerm_kubernetes_cluster.aks_vnet,
    module.aks_vnet_addons
  ]

  tags = local.tags
}

module "aks_vnet_nodepool_green" {
  count = var.sys_sh_is_green_deployed ? 1 : 0

  # DO NOT change below module source and the comment --> source = "./modules/aksnodepools" # Green
  source = "./modules/aksnodepools" # Green

  deployment_name    = local.deployment_name_green
  kubernetes_version = local.kubernetes_version
  aks_cluster_id     = azurerm_kubernetes_cluster.aks_vnet.id
  system_vm_size     = local.sh_aks_system_vm_size
  service_vm_size    = local.sh_aks_valkey_vm_size
  node_subnet_id     = azurerm_subnet.aks_node_snet.id
  pod_subnet_id      = azurerm_subnet.aks_pod_snet.id

  max_pods               = local.sh_aks_vnet_max_pods
  service_node_count     = local.sh_valkey_nodepool.node_count
  service_min_node_count = local.sh_valkey_nodepool.min_node_count
  service_max_node_count = local.sh_valkey_nodepool.max_node_count

  depends_on = [
    azurerm_kubernetes_cluster.aks_vnet,
    module.aks_vnet_addons
  ]

  tags = local.tags
}