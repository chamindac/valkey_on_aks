#region locals
locals {

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

variable "region" {
  description = "Azure region to deploy resources"
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