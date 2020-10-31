# Cloud Adoption Framework for Azure - Landing zones on Terraform - Data Analytics Platform

Microsoft Cloud Adoption Framework for Azure provides you with guidance and best practices to adopt Azure.

A landing zone is a segment of a cloud environment, that has been preprovisioned through code, and is dedicated to the support of one or more workloads. Landing zones provide access to foundational tools and controls to establish a compliant place to innovate and build new workloads in the cloud, or to migrate existing workloads to the cloud. Landing zones use defined sets of cloud services and best practices to set you up for success.

## Goals

The data analytics & AI landing zones sits on top of Cloud Adoption Framework for Azure foundational landing zones and enables the deployment of Data Platform Services on top of it.

You can find the core landing zones here: [CAF landing zones](https://github.com/Azure/caf-terraform-landingzones/)

Data analytics landing zone foundation: 

![Landing zone architecture](./_images/data_analytics_platform.PNG)

## Getting Started

Clone this repo on your local machine and follow the to [examples section](./examples) to get started and deploy an Data Analytics Platform landing zone.

## Related repositories

| Repo                                                                                              | Description                                                |
|---------------------------------------------------------------------------------------------------|------------------------------------------------------------|
| [caf-terraform-landingzones](https://github.com/azure/caf-terraform-landingzones)                 | landing zones repo with sample and core documentations     |
| [rover](https://github.com/aztfmod/rover)                                                         | devops toolset for operating landing zones                 |
| [azure_caf_provider](https://github.com/aztfmod/terraform-provider-azurecaf)                      | custom provider for naming conventions                     |
| [modules](https://registry.terraform.io/modules/aztfmod)   


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
git clone -b 0.4 https://github.com/aztfmod/terraform-azurerm-caf.git /tf/caf/public

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

## Community

Feel free to open an issue for feature or bug, or to submit a PR.

In case you have any question, you can reach out to tf-landingzones at microsoft dot com.

You can also reach us on [Gitter](https://gitter.im/aztfmod/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

## Code of conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
