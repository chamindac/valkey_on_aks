#region locals
locals {

  instance_name              = "${var.environment}-${var.region_short_code}-${var.instance_id}"
  instance_short_name        = "${var.environment}${var.region_short_code}${var.instance_id}"
  resource_name_prefix       = "${var.prefix}-${var.project_code}-${local.instance_name}"
  resource_short_name_prefix = "${var.prefix}${var.project_code}${local.instance_short_name}"

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