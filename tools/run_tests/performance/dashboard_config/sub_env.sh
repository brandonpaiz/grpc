#!/bin/bash

# This script checks that all necessary environment variables have been set,
# then makes substitutes them where needed.

check_env () {
  env_vars=("$@")
  missing_var=0
  for var in "${env_vars[@]}"; do
    if [ -z "${!var}" ]; then
      echo "${var} not set"
      missing_var=1
    fi
  done
  return $missing_var
}

substitute_env_in_files () {
  files=("$@")
  for file in "${files[@]}"; do
    tmp=$(mktemp)
    echo "Making substitutions in ${file}"
    cp --attributes-only --preserve ${file} ${tmp}
    cat ${file} | envsubst > $tmp && mv $tmp $file
  done
}

check_env GCP_PROJECT_ID GCP_GRAFANA_SERVICE GCP_DATA_TRANSFER_SERVICE BQ_PROJECT_ID PG_USER PG_PASS PG_DATABASE GRAFANA_ADMIN_PASS CLOUD_SQL_INSTANCE || exit 1

substitute_env_in_files \
  "./grafana/app.yaml" \
  "./postgres_migrator/app.yaml" \
  "./postgres_migrator/config/transfer.yaml"

