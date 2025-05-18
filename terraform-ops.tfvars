azure_tennant_id = "1e90e501-da91-4b1f-8305-d6091c3528f5"

azure_subscription = "7f4fc141-03a3-4faf-b193-b7e310b6ee15"

azure_resource_group = "rg-hive-deploy-ops"
azure_resource_group_location = "West Europe"

storage_account_name = "sthivedeployops"

tags = {
  product = "hivebuilder"
  environment = "prd"
  project = "product"
  customer = "shared" #obsolete, should be removed. Modules should be adapted
  tenantcluster = "shared-we-01"
  tenant = "shared"
}

github_oidc_federated_identity_credentials = [
  // build actions
  {
    display_name = "hive-collaboration-service-build-action"
    subject      = "repo:hivebuilder/hive-collaboration-service:ref:refs/heads/main"
  },
  {
    display_name = "hive-config-service-build-action"
    subject      = "repo:hivebuilder/hive-config-service:ref:refs/heads/main"
  },
  {
    display_name = "hive-doc-service-build-action"
    subject      = "repo:hivebuilder/hive-doc-service:ref:refs/heads/main"
  },
  {
    display_name = "hive-keeper-service-build-action"
    subject      = "repo:hivebuilder/hive-keeper-service:ref:refs/heads/main"
  },
  // prd actions
  {
    display_name = "hive-collaboration-service-deploy-action-prd"
    subject      = "repo:hivebuilder/hive-collaboration-service:environment:prd"
  },
  {
    display_name = "hive-config-service-deploy-action-prd"
    subject      = "repo:hivebuilder/hive-config-service:environment:prd"
  },
  {
    display_name = "hive-doc-service-deploy-action-prd"
    subject      = "repo:hivebuilder/hive-doc-service:environment:prd"
  },
  {
    display_name = "hive-keeper-service-deploy-action-prd"
    subject      = "repo:hivebuilder/hive-keeper-service:environment:prd"
  },
  // tst actions
  {
    display_name = "hive-collaboration-service-deploy-action-tst"
    subject      = "repo:hivebuilder/hive-collaboration-service:environment:tst"
  },
  {
    display_name = "hive-config-service-deploy-action-tst"
    subject      = "repo:hivebuilder/hive-config-service:environment:tst"
  },
  {
    display_name = "hive-doc-service-deploy-action-tst"
    subject      = "repo:hivebuilder/hive-doc-service:environment:tst"
  },
  {
    display_name = "hive-keeper-service-deploy-action-tst"
    subject      = "repo:hivebuilder/hive-keeper-service:environment:tst"
  },
  // dev actions
  {
    display_name = "hive-collaboration-service-deploy-action-dev"
    subject      = "repo:hivebuilder/hive-collaboration-service:environment:dev"
  },
  {
    display_name = "hive-config-service-deploy-action-dev"
    subject      = "repo:hivebuilder/hive-config-service:environment:dev"
  },
  {
    display_name = "hive-doc-service-deploy-action-dev"
    subject      = "repo:hivebuilder/hive-doc-service:environment:dev"
  },
  {
    display_name = "hive-keeper-service-deploy-action-dev"
    subject      = "repo:hivebuilder/hive-keeper-service:environment:dev"
  },
]
