# Introduction to data analytics landing zone

Welcome to Cloud Adoption Framework for Azure: Terraform landing zones.

This landing zone is a starter for data analytics platform that stacks on top of **landingzone_caf_foundations** and **landingzone_networking**

### Data analytics landing zone foundation
![Landing zone architecture](./_images/data_analytics_platform.PNG)

### Components
| Examples | Description|
|----------|------------|
|datalake | Create datalake account |
|synapse | Synapse analytics workspace |
|aml | Machine Learning workspace for auto ml |
|module_azure_storage | Re-usable module to create the storage account |

## Prerequisites

This landing zone is a "level 2" type of landing zone, which requires you have set the foundations. The supported lower level landing zone is "caf_foundations" which can be found in the same release and must have been applied successfully before applying this one.

## Developping this landing zone

Those are the minimum steps to allow a single devops engineer. 

If the subscription is shared across multiple devops engineer is it recommended each devops engineer use their own launchpad to avoid any conflicts between devops engineers. This can be achieved by setting a specific environment variable value. In the following script we use the environment value of "asia".

```bash
# Login the Azure subscription
rover login -t terraformdev.onmicrosoft.com -s [subscription GUID]
# Environment is needed to be defined, otherwise the below LZs will land into sandpit which someone else is working on
# Set the environment
export TF_VAR_environment="MoonStar"

# Set the example folder
export example="101-simple_cluster"

```

## Apply the landing zone (launchpad, foundation and networking hub)
```bash
# Clone the public landing zones
# git clone git@github.com:aztfmod/terraform-azurerm-caf-enterprise-scale.git /tf/caf/public
git clone -b RS-analytics https://github.com/aztfmod/terraform-azurerm-caf-enterprise-scale.git /tf/caf/public

# or refresh
cd /tf/caf/public
git pull

# Add the launchpad landingzone if not yet deployed
# rover -lz /tf/caf/public/landingzones/caf_launchpad -launchpad -var-file /tf/caf/public/landingzones/caf_launchpad/scenario/200/configuration.tfvars -a apply
rover -lz /tf/caf/public/landingzones/caf_launchpad -launchpad -var-file /tf/caf/public/landingzones/caf_launchpad/scenario/100/configuration.tfvars -a apply

## To deploy dependencies for accounting, apply caf foundations.
rover -lz /tf/caf/public/landingzones/caf_foundations \
      -a apply

# Deploy the networking hub
# rover -lz /tf/caf/public/landingzones/caf_networking/ \
#      -tfstate networking_hub.tfstate \
#      -var-file /tf/caf/public/landingzones/caf_networking/scenario/200-single-region-hub/configuration.tfvars \
#      -a apply
rover -lz /tf/caf/public/landingzones/caf_networking/ \
      -tfstate networking_hub.tfstate \
      -var-file /tf/caf/public/landingzones/caf_networking/scenario/100-single-region-hub/configuration.tfvars \
      -a apply

# Deploy the spoke networking for Databricks that will peer the networking hub
rover -lz /tf/caf/public/landingzones/caf_networking/ \
      -var-file /tf/caf/examples/databricks/${example}/networking_spoke.tfvars \
      -tfstate networking_spoke_databricks.tfstate \
      -a apply
```

## Deploy the Databricks construction set
```bash
# The Databricks construction set is banse
export base_landingzone_tfstate_name="databricks_workspace.tfstate"
# Deploy Azure services for Databricks workspace
rover -lz /tf/caf \
      -var-file /tf/caf/examples/databricks/${example}/databricks.tfvars \
      -tfstate ${base_landingzone_tfstate_name} \
      -a apply

# Configure the Databricks cluster
rover -lz /tf/caf/add-ons/databricks \
      -var-file /tf/caf/examples/databricks/${example}/databricks.tfvars \
      -tfstate databricks.tfstate \
      -var tfstate_key=${base_landingzone_tfstate_name} \
      -a apply
```

## Deleting the development environment

Have fun playing with the landing zone and once you are done, you can simply delete the deployment replacing the ```-a apply``` with ```-a destroy``` in the previous commands.

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| azuread | ~> 1.0.0 |
| azurecaf | 1.0.0 |
| azurerm | ~> 2.27.0 |
| databricks | ~> 0.2.5 |
| external | ~> 1.2.0 |
| null | ~> 2.1.0 |
| random | ~> 2.2.1 |
| tls | ~> 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 2.27.0 |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aks\_clusters | n/a | `map` | `{}` | no |
| app\_service\_environments | n/a | `map` | `{}` | no |
| app\_service\_plans | n/a | `map` | `{}` | no |
| app\_services | n/a | `map` | `{}` | no |
| azure\_container\_registries | n/a | `map` | `{}` | no |
| azuread\_groups | n/a | `map` | `{}` | no |
| azurerm\_application\_insights | n/a | `map` | `{}` | no |
| azurerm\_redis\_caches | n/a | `map` | `{}` | no |
| bastion\_hosts | n/a | `map` | `{}` | no |
| databricks | n/a | `map` | `{}` | no |
| databricks\_workspaces | n/a | `map` | `{}` | no |
| diagnostic\_storage\_accounts | n/a | `map` | `{}` | no |
| diagnostics\_definition | n/a | `any` | `null` | no |
| environment | n/a | `string` | `"sandpit"` | no |
| global\_settings | n/a | `map` | `{}` | no |
| keyvault\_access\_policies | n/a | `map` | `{}` | no |
| keyvaults | n/a | `map` | `{}` | no |
| landingzone\_name | n/a | `string` | `"appservices"` | no |
| level | n/a | `string` | `"level3"` | no |
| logged\_aad\_app\_objectId | n/a | `any` | `null` | no |
| logged\_user\_objectId | n/a | `any` | `null` | no |
| lowerlevel\_container\_name | n/a | `any` | n/a | yes |
| lowerlevel\_key | n/a | `any` | n/a | yes |
| lowerlevel\_resource\_group\_name | n/a | `any` | n/a | yes |
| lowerlevel\_storage\_account\_name | Map of the remote data state for lower level | `any` | n/a | yes |
| managed\_identities | n/a | `map` | `{}` | no |
| max\_length | n/a | `number` | `40` | no |
| mssql\_servers | n/a | `map` | `{}` | no |
| network\_security\_group\_definition | n/a | `any` | `null` | no |
| private\_dns | n/a | `map` | `{}` | no |
| public\_ip\_addresses | n/a | `map` | `{}` | no |
| resource\_groups | n/a | `any` | `null` | no |
| role\_mapping | n/a | `map` | `{}` | no |
| rover\_version | n/a | `any` | `null` | no |
| storage\_accounts | n/a | `map` | `{}` | no |
| synapse\_workspaces | n/a | `map` | `{}` | no |
| tags | n/a | `map` | `null` | no |
| tfstate\_container\_name | n/a | `any` | n/a | yes |
| tfstate\_key | n/a | `any` | n/a | yes |
| tfstate\_resource\_group\_name | n/a | `any` | n/a | yes |
| tfstate\_storage\_account\_name | n/a | `any` | n/a | yes |
| tfstates | n/a | `map` | <pre>{<br>  "caf_foundations": {<br>    "tfstate": "caf_foundations.tfstate"<br>  },<br>  "networking": {<br>    "tfstate": "caf_foundations.tfstate"<br>  }<br>}</pre> | no |
| virtual\_machines | n/a | `map` | `{}` | no |
| vnets | n/a | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| caf | n/a |
| diagnostics | n/a |
| global\_settings | n/a |
| tfstates | n/a |

<!--- END_TF_DOCS --->