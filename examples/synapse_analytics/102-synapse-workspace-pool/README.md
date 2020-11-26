## Components deployed by this example

| Component         | Type of resource | Purpose                                                 |
|-------------------|------------------|---------------------------------------------------------|
| resource group    | Resource group   | resource group to host the workspace and instance pools |
| synapse workspace | Workspace        | synapse workspace                                       |
| spark pool        | compute          | spark compute cluster                                   |
| sql pool          | compute          | sql compute cluster                                     |

## Deploying this example

Ensure the below is set prior to apply or destroy.

```bash
# Login the Azure subscription
rover login -t [TENANT_ID/TENANT_NAME] -s [SUBSCRIPTION_GUID]
# Environment is needed to be defined, otherwise the below LZs will land into sandpit which someone else is working on
export environment=[YOUR_ENVIRONMENT]
```

## Deploy Azure services for Synapse Workspace

```bash
# Set the folder name - for workspace with dedicated spark or sql pool
export example="102-synapse-workspace-pool"   

	  
rover -lz /tf/caf/landingzone_data_analytics \
      -var-file /tf/caf/landingzone_data_analytics/examples/synapse_analytics/${example}/configuration.tfvars \
      -tfstate synapse_analytics.tfstate \
      -env ${environment} \
	  -level level3 \
      -a [plan|apply]
      
```

## Destroy an DAP landing zone deployment

Have fun playing with the landing zone an once you are done, you can simply delete the deployment using:

```bash       
rover -lz /tf/caf/landingzone_data_analytics \
      -var-file /tf/caf/landingzone_data_analytics/examples/synapse_analytics/${example}/configuration.tfvars \
      -tfstate synapse_analytics.tfstate \
      -env ${environment} \
	  -level level3 \
      -a destroy -auto-approve     
```
