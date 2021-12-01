#!/bin/bash

set -ex

# Copy postgres migrator and grafana template
git clone --branch database_migrator --depth 1 https://github.com/brandonpaiz/test-infra
# TODO when tools merged into test-infra: git clone --depth 1 https://github.com/grpc/test-infra
cp -r test-infra/tools/postgres_migrator .
cp -r test-infra/tools/grafana .

# Configure database migrator
cp postgres_migrator_config/transfer.yaml postgres_migrator/config/transfer.yaml
cp postgres_migrator_config/Dockerfile postgres_migrator
cp postgres_migrator_config/app.yaml postgres_migrator

# Configure grafana
cp grafana_config/app.yaml grafana
cp -r grafana_config/provisioning grafana
cp -r grafana_config/dashboards grafana

# Inject envrionment variables
./sub_env.sh
