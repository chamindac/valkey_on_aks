variable "acr_id" {
  description = "ID of the ACR to pull the images from."
  type        = string
}

variable "cluster_kubelet_object_id" {
  description = "Object ID of the AKS kubelet identity that pulls images from the shared container registry."
  type        = string
}

variable "node_resource_group_name" {
  description = "Name of the AKS node resource group."
  type        = string
}

variable "sub_owners_objectid" {
  description = "Object ID of the subscription owners group."
  type        = string
}