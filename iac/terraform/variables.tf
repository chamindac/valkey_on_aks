#region locals
locals {

  kubernetes_version = "1.36.3"

  instance_name              = "${var.environment}-${var.region_short_code}-${var.instance_id}"
  instance_short_name        = "${var.environment}${var.region_short_code}${var.instance_id}"
  resource_name_prefix       = "${var.prefix}-${var.project_code}-${local.instance_name}"
  resource_short_name_prefix = "${var.prefix}${var.project_code}${local.instance_short_name}"

  deployment_phase_deploy  = "deploy"
  deployment_phase_switch  = "switch"
  deployment_phase_destroy = "destroy"

  deployment_name_blue  = "blue"
  deployment_name_green = "green"

  # Cluster-wide max pods per node for the self-host AKS VNet cluster (Azure CNI Pod Subnet mode).
  sh_aks_vnet_max_pods  = 30
  sh_aks_system_vm_size = "Standard_D2s_v7"
  sh_aks_valkey_vm_size = "Standard_D4s_v7"

  # Self-host Valkey node pool sizing (3 nodes x 1 per zone; 9 pods = 3 shards x 2 replicas spread across zones).
  sh_valkey_nodepool = {
    node_count     = 3
    min_node_count = 3
    max_node_count = 15
  }

  aks_vnet_dns_prefix = "sh.aks.vnet"
  valkey_route_prefix = "valkey"

  tags = {
    Environment             = var.environment
    Owner                   = "Chaminda"
    System                  = "${var.environment}_iac"
    SystemClassification    = "restricted - proprietary information"
    CreatedBy               = data.azurerm_client_config.current.object_id
    Project                 = "${var.environment}_iac"
    FiscalEntity            = "demo"
    SourceControlManagement = "github.com/chamindac/valkey_on_aks"
  }
}
#endregion locals

#region common variables
variable "environment" {
  description = "Environment for the deployment (e.g., poc, dev, prod, qa, shared)"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "project_code" {
  description = "Project code for resource names"
  type        = string
}

variable "instance_id" {
  description = "Instance ID for resource names"
  type        = string
}

variable "region" {
  description = "Azure region to deploy resources"
  type        = string
}

variable "region_short_code" {
  description = "Short code for the Azure region"
  type        = string
}

variable "subscription_id" {
  description = "Target (management) Azure subscription id.If we go with core subscription in future, this will be the core subscription id"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant id"
  type        = string
}
#endregion common variables

#region networking variables
variable "aks_node_subnet_cidr" {
  description = "CIDR block for the AKS node subnet"
  type        = string
}

variable "aks_pod_subnet_cidr" {
  description = "CIDR block for the AKS pod subnet"
  type        = string
}
#endregion networking variables

#region Nginx-Gateway
variable "sh_private_ip_nginx_gateway_vnet" {
  description = "Selfhost AKS vnet private IP in aks_node_subnet_cidr for Nginx-Gateway"
  type        = string
}
#endregion Nginx-Gateway

#region Valkey
variable "sh_private_ip_valkey" {
  description = "Selfhost AKS vnet private IP in aks_node_subnet_cidr for Valkey bootstrap internal LB"
  type        = string
}
#endregion Valkey

#region Blue-Green deployment control variables
variable "sys_sh_is_blue_deployed" {
  type = bool
}

variable "sys_sh_is_green_deployed" {
  type = bool
}

variable "sys_sh_is_green_live" {
  type = bool
}

variable "sys_sh_deployment_phase" {
  type = string

  validation {
    condition     = contains(["deploy", "switch", "destroy"], var.sys_sh_deployment_phase)
    error_message = "Valid values for var.sys_sh_deployment_phase are: (deploy, switch or destroy)."
  }
}
#endregion