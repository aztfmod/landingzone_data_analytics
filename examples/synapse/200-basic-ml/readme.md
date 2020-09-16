
```bash
# Refresh public repository
cd /tf/caf/public
git pull

# Hub networking (Optional if alrady deployed)
rover -lz /tf/caf/public/landingzones/caf_networking/ -var-file /tf/caf/public/landingzones/caf_networking/scenario/200-single-region-hub/configuration.tfvars -tfstate networking_hub.tfstate -a apply


# Set the following variable environment
export example="200-basic-ml"

# Dap spoke network
rover -lz /tf/caf/public/landingzones/caf_networking/ -var-file /tf/caf/examples/synapse/${example}/networking_spoke.tfvars -tfstate ${example}-networking_spoke.tfstate -a apply

# Data Analytics Platform
rover -lz /tf/caf -var-file /tf/caf/examples/synapse/${example}/configuration.tfvars -tfstate ${example}.tfstate -a apply

```