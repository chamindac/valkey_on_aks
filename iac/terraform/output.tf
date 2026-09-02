# New region/env deployments no live aks nodepool until pipeline completed for all stages
# Existing environment blue or green can be live
output "live_aks_nodepool" {
  value = var.sys_sh_is_green_live ? (
    var.sys_sh_is_green_deployed ? local.deployment_name_green : "No live aks nodepool"
    ) : (
    local.deployment_name_blue
  )
}

output "aks_uai_client_id" {
  value = azurerm_user_assigned_identity.aks_uai.client_id
}

output "svc_deploy_nodepool_suffix" {
  value = var.sys_sh_is_green_live ? (
    var.sys_sh_deployment_phase == "deploy" ? (
      var.sys_sh_is_blue_deployed ? local.deployment_name_blue : local.deployment_name_green
      ) : (
      local.deployment_name_green
    )
    ) : (
    var.sys_sh_deployment_phase == "deploy" ? (
      var.sys_sh_is_green_deployed ? local.deployment_name_green : local.deployment_name_blue
      ) : (
      local.deployment_name_blue
    )
  )
}

output "svc_deploy_dns_zone_vnet" {
  value = trimsuffix(replace(azurerm_private_dns_a_record.aks_vnet_nginx.fqdn, "*", ""), ".")
}