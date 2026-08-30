#region common variables
variable "environment" {
  description = "Environment for the deployment (e.g., dev, prod, qa, shared)"
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