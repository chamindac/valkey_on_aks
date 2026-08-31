data "azurerm_container_registry" "cr" {
  name                = "${var.prefix}${var.environment}acr"
  resource_group_name = "${var.prefix}-${var.environment}-acr-rg"
}

resource "azurerm_kubernetes_cluster" "aks_vnet" {

  lifecycle {
    ignore_changes  = [default_node_pool[0].node_count]
    prevent_destroy = true
  }

  name                         = "${local.resource_name_prefix}-aks-vnet"
  kubernetes_version           = local.kubernetes_version
  sku_tier                     = "Standard"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  dns_prefix                   = "${local.resource_name_prefix}-aks-vnet-dns"
  node_resource_group          = "${local.resource_name_prefix}-aks-vnet-rg"
  image_cleaner_enabled        = false # As this is a preview feature keep it disabled for now. Once feture is GA, it should be enabled.
  image_cleaner_interval_hours = 48

  node_provisioning_profile {
    default_node_pools = "None"
    mode               = "Manual"
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "cilium"
    network_data_plane = "cilium"
    load_balancer_sku  = "standard"
  }

  storage_profile {
    blob_driver_enabled         = false
    disk_driver_enabled         = true
    file_driver_enabled         = true
    snapshot_controller_enabled = true
  }

  default_node_pool {
    name                         = "${var.project_code}default"
    orchestrator_version         = local.kubernetes_version
    auto_scaling_enabled         = true
    node_count                   = 1
    min_count                    = 1
    max_count                    = 3
    max_pods                     = 30
    scale_down_mode              = "Delete"
    vm_size                      = "Standard_D2s_v6"
    os_sku                       = "Ubuntu"
    os_disk_type                 = "Managed"
    vnet_subnet_id               = azurerm_subnet.aks_node_snet.id
    pod_subnet_id                = azurerm_subnet.aks_pod_snet.id
    type                         = "VirtualMachineScaleSets"
    zones                        = ["1", "2", "3"]
    temporary_name_for_rotation  = "rvnetdef"
    only_critical_addons_enabled = true # Taint as CriticalAddonsOnly=true:NoSchedule

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  auto_scaler_profile {
    scale_down_unneeded              = "10m"
    scale_down_utilization_threshold = 0.5
    scale_down_delay_after_add       = "10m"
    scale_down_delay_after_failure   = "3m"
    expander                         = "priority"
  }

  monitor_metrics {
    annotations_allowed = null
    labels_allowed      = null
  }

  timeouts {
    create = "180m"
    update = "180m"
    delete = "180m"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_uai.id]
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = false
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = false
    tenant_id          = var.tenant_id

    admin_group_object_ids = [data.azuread_group.sub_owners.object_id]
  }

  oms_agent {
    log_analytics_workspace_id      = azurerm_log_analytics_workspace.log_analytics_workspace.id
    msi_auth_for_monitoring_enabled = true
  }

  depends_on = [
    azurerm_resource_group.rg,
    azurerm_log_analytics_workspace.log_analytics_workspace,
    azurerm_subnet.aks_node_snet,
    azurerm_subnet.aks_pod_snet,
    azurerm_user_assigned_identity.aks_uai,
    azurerm_role_assignment.aks_uai_aks_node_snet,
    azurerm_role_assignment.aks_uai_aks_pod_snet,
    azurerm_network_security_group.nsg,
    azurerm_subnet_network_security_group_association.aks_node_snet_nsg,
    azurerm_subnet_network_security_group_association.aks_pod_snet_nsg
  ]

  tags = merge(tomap({
    Service = "aks vnet cluster"
  }), local.tags)
}
