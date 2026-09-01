#region common variables
environment       = "poc"
prefix            = "ch"
project_code      = "vk"
instance_id       = "001"
region            = "eastus2"
region_short_code = "eus"
subscription_id   = "#{subscription_id}#"
tenant_id         = "#{tenant_id}#"
#endregion common variables

#region networking variables
aks_node_subnet_cidr = "10.12.0.0/21"
aks_pod_subnet_cidr  = "10.12.8.0/21"
#endregion networking variables

#region Blue-Green deployment control variables
sys_sh_is_blue_deployed  = "#{sys_sh_is_blue_deployed}#"
sys_sh_is_green_deployed = "#{sys_sh_is_green_deployed}#"
sys_sh_is_green_live     = "#{sys_sh_is_green_live}#"
sys_sh_deployment_phase  = "#{sys_sh_deployment_phase}#"
#endregion