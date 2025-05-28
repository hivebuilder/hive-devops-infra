terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-shared"
    storage_account_name = "stortfstates8q9he9qg6jom"
    container_name       = "tf-states"
    //key                  = local.remote_state_key
  }
}

provider "azurerm" {
  subscription_id = var.azure_subscription
  features {    
  }
}

provider "azuread" {
  tenant_id = var.azure_tennant_id
}


resource "azurerm_resource_group" "rg_hive_deploy_ops" {
  name     = var.azure_resource_group
  location = var.azure_resource_group_location

  tags = var.tags
}

module "stor_hive_deploy_ops" {
  source = "git@github.com:hivebuilder/bg-tf-azure-modules.git//storage/storage_account"

  azure_resource_group_name     = azurerm_resource_group.rg_hive_deploy_ops.name
  azure_resource_group_location = azurerm_resource_group.rg_hive_deploy_ops.location

  storage_account_name = var.storage_account_name

  tags = var.tags
}

resource "azurerm_storage_container" "artifacts" {
  name                  = "artifacts"
  storage_account_id    = module.stor_hive_deploy_ops.storage_account_id
  container_access_type = "private"
}

resource "azurerm_container_registry" "acr" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.rg_hive_deploy_ops.name
  location            = azurerm_resource_group.rg_hive_deploy_ops.location
  sku                 = var.container_registry_sku

  admin_enabled = false

  tags = var.tags
}

resource "azuread_application" "github" {
  display_name = "Hive GitHub OIDC Deployer"
}

resource "azuread_service_principal" "github" {
  client_id = azuread_application.github.client_id
}

resource "azuread_application_federated_identity_credential" "github_oidc" {
  for_each = { for cred in var.github_oidc_federated_identity_credentials : cred.display_name => cred }

  application_id       = azuread_application.github.id
  display_name         = each.value.display_name
  description          = "OIDC federated identity for GitHub Actions"
  audiences            = ["api://AzureADTokenExchange"]
  issuer               = "https://token.actions.githubusercontent.com"
  subject              = each.value.subject
}

resource "azurerm_role_assignment" "github_oidc_contributor" {
  scope                = "/subscriptions/${var.azure_subscription}"
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.github.object_id
  depends_on           = [azuread_application_federated_identity_credential.github_oidc]
}

resource "azurerm_role_assignment" "github_oidc_storage_blob_contributor" {
  scope                = module.stor_hive_deploy_ops.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.github.object_id
  depends_on           = [module.stor_hive_deploy_ops]
}

resource "azurerm_role_assignment" "acr_push" {
  principal_id         = azuread_service_principal.github.object_id
  role_definition_name = "AcrPush"
  scope                = azurerm_container_registry.acr.id
}
