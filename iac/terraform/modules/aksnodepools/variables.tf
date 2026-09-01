variable "deployment_name" {
  description = "Deployment name blue or green"

  validation {
    condition     = contains(["blue", "green"], var.deployment_name)
    error_message = "Valid values for var.deployment_name are: (blue, green)."
  }
}
variable "kubernetes_version" {
  description = "The Kubernetes version to use for the node pool."
  type        = string
}

variable "aks_cluster_id" {
  description = "The ID of the AKS cluster to which the node pool belongs."
  type        = string
}

variable "system_vm_size" {
  description = "The size of the Virtual Machines in the system node pool."
  type        = string
}

variable "service_vm_size" {
  description = "The size of the Virtual Machines in the service node pool."
  type        = string
}

variable "node_subnet_id" {
  description = "The id of the node subnet where the cluster nodes will be located"
  type        = string
}

variable "pod_subnet_id" {
  description = "The id of the pod subnet (Azure CNI Pod Subnet mode). Leave null for Overlay clusters."
  type        = string
  default     = null
}

variable "max_pods" {
  description = "Maximum pods per node. 250 for Azure CNI Overlay, 30 for Azure CNI Pod Subnet."
  type        = number
}

variable "service_node_count" {
  description = "Initial node count for the service node pool."
  type        = number
}

variable "service_min_node_count" {
  description = "Minimum node count for the service node pool."
  type        = number
}

variable "service_max_node_count" {
  description = "Maximum node count for the service node pool."
  type        = number
}

variable "tags" {
  description = "Map of tags to assign to the Cluster"
  type        = map(string)
}