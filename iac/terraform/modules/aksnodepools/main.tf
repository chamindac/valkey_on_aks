# Disabled deploying additional system node pool for POC to avoid cost
# Should be enabled for production deployments to ensure addtional system node pool to support AKS upgrades
# resource "azurerm_kubernetes_cluster_node_pool" "aks_sys" {

#   lifecycle {
#     ignore_changes = [node_count]
#   }

#   name                        = "sys${var.deployment_name}"
#   mode                        = "System"
#   orchestrator_version        = var.kubernetes_version
#   kubernetes_cluster_id       = var.aks_cluster_id
#   auto_scaling_enabled        = true
#   node_count                  = 1
#   min_count                   = 1
#   max_count                   = 3
#   max_pods                    = var.max_pods
#   scale_down_mode             = "Delete"
#   vm_size                     = var.system_vm_size
#   os_type                     = "Linux"
#   os_sku                      = "Ubuntu"
#   os_disk_type                = "Managed" # os_disk_size_gb      = 300  # Optional — default Standard_D8ds_v4 disk size is 300 GiB
#   vnet_subnet_id              = var.node_subnet_id
#   pod_subnet_id               = var.pod_subnet_id
#   zones                       = ["1", "2", "3"]
#   temporary_name_for_rotation = "rsys${var.deployment_name}"
#   priority                    = "Regular"

#   upgrade_settings {
#     drain_timeout_in_minutes      = 0
#     max_surge                     = "10%"
#     node_soak_duration_in_minutes = 0
#   }

#   # Ensure only system pods are scheduled on this node pool
#   node_taints = [
#     "CriticalAddonsOnly=true:NoSchedule"
#   ]

#   timeouts {
#     update = "180m"
#     delete = "180m"
#   }

#   tags = merge(tomap({
#     Service = "aks_cluster_system_nodepool"
#   }), var.tags)
# }

resource "azurerm_kubernetes_cluster_node_pool" "aks_sh" {

  lifecycle {
    ignore_changes = [node_count]
  }

  name                        = "sh${var.deployment_name}"
  mode                        = "User"
  orchestrator_version        = var.kubernetes_version
  kubernetes_cluster_id       = var.aks_cluster_id
  auto_scaling_enabled        = true
  node_count                  = var.service_node_count
  min_count                   = var.service_min_node_count
  max_count                   = var.service_max_node_count
  max_pods                    = var.max_pods
  scale_down_mode             = "Delete"
  vm_size                     = var.service_vm_size
  os_type                     = "Linux"
  os_sku                      = "Ubuntu"
  os_disk_type                = "Managed"
  vnet_subnet_id              = var.node_subnet_id
  pod_subnet_id               = var.pod_subnet_id
  zones                       = ["1", "2", "3"]
  temporary_name_for_rotation = "rsh${var.deployment_name}"
  priority                    = "Regular"

  upgrade_settings {
    drain_timeout_in_minutes      = 0
    max_surge                     = "10%"
    node_soak_duration_in_minutes = 0
  }

  # Ensure only self-hosted pods are scheduled on this node pool with blue or green constraints
  node_taints = [
    "nodepool=sh${var.deployment_name}:NoSchedule"
  ]

  timeouts {
    update = "180m"
    delete = "180m"
  }

  tags = merge(tomap({
    Service = "aks_cluster_selfhost_nodepool"
  }), var.tags)
}