# CAF landing zones for Terraform - Azure Machine Learning (AML) example

Deploys a AML Workspace \.

DAP landing zone operates at **level 3**.

For a review of the hierarchy approach of Cloud Adoption Framework for Azure landing zones on Terraform, you can refer to [the following documentation](../../../../documentation/code_architecture/hierarchy.md).

## Prerequisites

Before running this example, please make sure you have setup your environment as described in the [following guide](../../readme.md)

## Architecture diagram

This example will sit on the [prerequisites environment](../../readme.md) and will allow you to deploy the following additional topology:

![solutions](../../../_images/examples/101-databricks-architecture.png)

## Components deployed by this example

| Component                | Type of resource                 | Purpose                                                        |
|--------------------------|----------------------------------|----------------------------------------------------------------|
| resource group           | Resource group                   | resource group to host the cluster and the compute resources   |
| Machin Learning Workspace| Workspace                        | machine learning workspace                                     |
                            

## Deploying this example

Ensure the below is set prior to apply or destroy.

```bash
# Login the Azure subscription
rover login -t [TENANT_ID/TENANT_NAME] -s [SUBSCRIPTION_GUID]
# Environment is needed to be defined, otherwise the below LZs will land into sandpit which someone else is working on
export environment=[YOUR_ENVIRONMENT]
```

## Deploy Machine Learning Workspace

```bash
# Set the folder name of this example
export example="101-aml-workspace"

rover -lz /tf/caf/landingzone_data_analytics \
      -var-file /tf/caf/landingzone_data_analytics/examples/machine_learning/${example}/configuration.tfvars \
      -tfstate machine_learning_101.tfstate \
	   -env ${environment} \
       -level level3 \
      -a [plan|apply]
```

## Destroy Machine Learning Workspace

To destroy the componenets you can run below command

```bash
# Set the folder name of this example
export example="101-aml-workspace"

rover -lz /tf/caf/landingzone_data_analytics \
      -var-file /tf/caf/landingzone_data_analytics/examples/machine_learning/${example}/configuration.tfvars \
      -tfstate machine_learning_101.tfstate \
	   -env ${environment} \
       -level level3 \
       -a destroy -auto-approve
```
