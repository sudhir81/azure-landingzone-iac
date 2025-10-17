variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "eastus"
}

variable "project" {
  description = "Project name prefix for all resources."
  type        = string
  default     = "lz"
}

variable "hub_cidr" {
  description = "CIDR range for the Hub virtual network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "spoke_cidr" {
  description = "CIDR range for the Spoke virtual network."
  type        = string
  default     = "10.10.0.0/16"
}

variable "rbac" {
  description = "RBAC assignment configuration."
  type = object({
    hub_contributors   = list(string)
    spoke_contributors = list(string)
    readers            = list(string)
  })
}

variable "subscription_id" {
  description = "The Azure Subscription ID (can be set via TF_VAR_subscription_id)."
  type        = string
}
