#!/bin/bash

# Simulated paths to workflow files
WORKFLOWS_DIR=".github/workflows"

if [[ "${{ inputs.testing_workflows }}" == "true" ]]; then
  echo "Adding testing workflows..."
  cp /templates/testing/*.yml $WORKFLOWS_DIR/
fi

if [[ "${{ inputs.linting_workflows }}" == "true" ]]; then
  echo "Adding linting workflows..."
  cp /templates/linting/*.yml $WORKFLOWS_DIR/
fi

if [[ "${{ inputs.building_workflows }}" == "true" ]]; then
  echo "Adding building workflows..."
  cp /templates/building/*.yml $WORKFLOWS_DIR/
fi

if [[ "${{ inputs.deployment_workflows }}" == "true" ]]; then
  echo "Adding deployment workflows..."
  cp /templates/deploying/*.yml $WORKFLOWS_DIR/
fi
