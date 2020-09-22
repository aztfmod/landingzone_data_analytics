
```bash
# Machine Learning Spoke Network
rover -lz /tf/caf/public/landingzones/caf_networking/ \
      -var-file /tf/caf/examples/azure_machine_learning/networking_spoke.tfvars \
      -tfstate networking_spoke_aml.tfstate \
      -a apply

# Machine Learning Workspace
rover -lz /tf/caf -var-file /tf/caf/examples/azure_machine_learning/configuration.tfvars \
-tfstate aml_workspace.tfstate \
-a apply
```
