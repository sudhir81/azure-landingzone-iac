terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0"
    }
  }
}

# --------------------------------------------
# 1️⃣ Deny Public IP - Enforce No Public IPs
# --------------------------------------------
resource "azurerm_subscription_policy_assignment" "deny_public_ip" {
  name                 = "deny-public-ip"
  display_name         = "Network interfaces should not have public IPs"
  subscription_id      = var.subscription_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114"
  location             = var.location
  description          = "Ensures that no network interfaces are created with public IP addresses."

  metadata = jsonencode({ assignedBy = "Terraform" })
}

# --------------------------------------------
# 2️⃣ Require Tag - Enforce Environment Tag (✅ BUILT-IN + PARAMETERS FIXED)
# --------------------------------------------
resource "azurerm_subscription_policy_assignment" "require_tags" {
  name                 = "require-environment-tag"
  display_name         = "Require 'Environment' tag on resources"
  subscription_id      = var.subscription_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62"
  location             = var.location
  description          = "Requires that all resources have the 'Environment' tag with the value 'Production'."

  metadata = jsonencode({ assignedBy = "Terraform" })

  parameters = jsonencode({
    tagName  = { value = "Environment" }
    tagValue = { value = "Production" }
  })
}

# --------------------------------------------
# 3️⃣ Audit Diagnostic Settings - With Required Parameters ✅
# --------------------------------------------
resource "azurerm_subscription_policy_assignment" "audit_diag" {
  name                 = "audit-diagnostics"
  display_name         = "Audit diagnostic settings for selected resource types"
  subscription_id      = var.subscription_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/7f89b1eb-583c-429a-8828-af049802c1d9"
  location             = var.location
  description          = "Audits diagnostic settings for specific Azure resource types."

  metadata = jsonencode({ assignedBy = "Terraform" })

  parameters = jsonencode({
    listOfResourceTypes = {
      value = [
        "Microsoft.Compute/virtualMachines",
        "Microsoft.Network/networkSecurityGroups",
        "Microsoft.Storage/storageAccounts"
      ]
    }
  })
}

# --------------------------------------------
# ✅ Outputs
# --------------------------------------------
output "deny_public_ip_id" {
  value = azurerm_subscription_policy_assignment.deny_public_ip.id
}

output "require_tags_id" {
  value = azurerm_subscription_policy_assignment.require_tags.id
}

output "audit_diag_id" {
  value = azurerm_subscription_policy_assignment.audit_diag.id
}
