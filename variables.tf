variable "azure_tennant_id" {
  type = string
  
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.azure_tennant_id))
    error_message = "The tenant ID must be a valid GUID."
  }
  
}

variable "azure_subscription" {
  type = string
}

variable "azure_resource_group" {
  type = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.azure_resource_group))
    error_message = "The resource group name must only contain alphanumeric characters and hyphens."
  }
}

variable "azure_resource_group_location" {
  type = string
}

variable "storage_account_name" {
  type = string
  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "The storage account name must be between 3 and 24 characters long and can only contain lowercase letters and numbers."
  }
}

variable "tags" {
  type = map(string)
  validation {
    condition = alltrue([
      contains(keys(var.tags), "product"),
      contains(keys(var.tags), "environment"),
      contains(keys(var.tags), "project"),
      contains(keys(var.tags), "customer")
    ])
    error_message = "The tags map must contain keys: product, environment, project, and customer."
  }
}

variable "github_oidc_federated_identity_credentials" {
  description = "List of objects with display_name and subject for azuread_application_federated_identity_credential"
  type = list(object({
    display_name = string
    subject      = string
  }))
  default = [
    {
      display_name = "github-actions"
      subject      = "repo:hivebuilder/hive-doc-service:ref:refs/heads/main"
    }
  ]
}
