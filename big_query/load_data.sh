#!/bin/bash

# 检查是否提供了数据库名称和文件夹名称
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <database_name> <folder_name>"
  exit 1
fi

project_id="advanceddb-405622"
database_name="$1"
folder_name="$2"
datasets=("CUSTOMER" "LINEITEM" "NATION" "ORDERS" "PART" "PARTSUPP" "REGION" "SUPPLIER")

for dataset in "${datasets[@]}"
do
  lowercase_dataset=$(echo "$dataset" | tr '[:upper:]' '[:lower:]')
  bq load --noreplace --source_format=CSV ${project_id}:${database_name}.${dataset} gs://bucket_bdma_adb/${folder_name}/${lowercase_dataset}.csv
done

