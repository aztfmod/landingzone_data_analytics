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

This landing zone is a "level 2" type of landing zone, which requires you have set the foundations. The supported lower level landing zone is "landingzone_caf_foundations" which can be found in the same release and must have been applied successfully before applying this one.

## Developping this landing zone

Those are the minimum steps to allow a single devops engineer. 

If the subscription is shared across multiple devops engineer is it recommended each devops engineer use their own launchpad to avoid any conflicts between devops engineers. This can be achieved by setting a specific environment variable value. In the following script we use the environment value of "asia".

Note - the script bellow is not covering a shared environment multiple devops engineer can get access and collaborate (coming later)

```bash
# Login the Azure subscription
rover login -t terraformdev.onmicrosoft.com -s [subscription GUID]
# Environment is needed to be defined, otherwise the below LZs will land into sandpit which someone else is working on
export TF_VAR_environment={Your Environment}
# Add the lower dependency landingzones
rover --clone-landingzones --clone-branch vnext13
# Deploy the launchpad light to store the tfstates
rover -lz /tf/caf/landingzones/launchpad -a apply -launchpad -var location=southeastasia

## To deploy the landing zones, some dependencies are required: caf foundations and networking
rover -lz /tf/caf/landingzones/landingzone_caf_foundations/ -a apply -var-file /tf/caf/configuration/landingzone_caf_foundations.tfvars
rover -lz /tf/caf/landingzones/landingzone_networking/ -a apply -var-file /tf/caf/configuration/landingzone_networking.tfvars 

# Run data landing zone deployment
rover -lz /tf/caf/ -tfstate landingzone_data.tfstate -a apply 
```

## Deleting the development environment

Have fun playing with the landing zone and once you are done, you can simply delete the deployment using:

```bash
rover -lz /tf/caf/ -tfstate landingzone_data.tfstate -a destroy -auto-approve
rover -lz /tf/caf/landingzones/landingzone_networking/ -a destroy -var-file /tf/caf/configuration/landingzone_networking.tfvars
rover -lz /tf/caf/landingzones/landingzone_caf_foundations/ -a destroy -var-file /tf/caf/configuration/landingzone_caf_foundations.tfvars

# to destroy the launchpad you need to conifrm you are connected with your user. If not reconnect with
rover login -t terraformdev.onmicrosoft.com -s [subscription GUID]

rover -lz /tf/caf/landingzones/launchpad -a destroy -launchpad
```

<!--- BEGIN_TF_DOCS --->
<!--- END_TF_DOCS --->