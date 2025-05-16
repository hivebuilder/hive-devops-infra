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

resource "azuread_application" "github" {
  display_name = "Hive GitHub OIDC Deployer"
}

resource "azuread_service_principal" "github" {
  client_id = azuread_application.github.client_id
}

resource "azuread_application_federated_identity_credential" "github_oidc" {
  for_each             = { for idx, val in var.github_oidc_federated_identity_credentials : idx => val }
  application_id       = azuread_application.github.id
  display_name         = each.value.display_name
  description          = "OIDC federated identity for GitHub Actions"
  audiences            = ["api://AzureADTokenExchange"]
  issuer               = "https://token.actions.githubusercontent.com"
  subject              = each.value.subject
}
