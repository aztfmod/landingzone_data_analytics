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
Error: Argument or block definition required: An argument or block definition is required here.

<!--- END_TF_DOCS --->