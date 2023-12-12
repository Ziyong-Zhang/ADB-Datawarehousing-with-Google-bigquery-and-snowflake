#!/bin/bash

# 检查是否提供了数据库名称、文件夹名称和数据集名称
if [ -z "$1" ] || [ -z "$2" ] ; then
  echo "Usage: $0 <database_name> <folder_name>"
  exit 1
fi

project_id="advanceddb-405622"
database_name="$1"
folder_name="$2"

datasets=("CUSTOMER" "LINEITEM" "NATION" "ORDERS" "PART" "PARTSUPP" "REGION" "SUPPLIER")
csv_file="loading_times.csv"

# 记录整个过程的开始时间
total_start_time=$(date +"%Y-%m-%d %H:%M:%S.%N")

# 创建CSV文件并写入列名
echo "Dataset,Loading Time" > "$csv_file"

for dataset in "${datasets[@]}"
do
  lowercase_dataset=$(echo "$dataset" | tr '[:upper:]' '[:lower:]')

  # 记录开始时间
  start_time=$(date +"%Y-%m-%d %H:%M:%S.%N")

  # 加载数据集
  bq load --noreplace --source_format=CSV ${project_id}:${database_name}.${dataset} gs://bucket_bdma_adb/${folder_name}/${lowercase_dataset}.csv

  # 记录结束时间
  end_time=$(date +"%Y-%m-%d %H:%M:%S.%N")

  # 计算加载时间（保留小数点后三位）
  loading_time=$(python -c "print('%.3f' % (($(date -d "$end_time" +"%s.%N") - $(date -d "$start_time" +"%s.%N"))))")

  # 将数据写入CSV文件
  echo "$dataset,$loading_time" >> "$csv_file"
done

# 记录整个过程的结束时间
total_end_time=$(date +"%Y-%m-%d %H:%M:%S.%N")

# 计算整个过程的总时间（保留小数点后三位）
total_loading_time=$(python -c "print('%.3f' % (($(date -d "$total_end_time" +"%s.%N") - $(date -d "$total_start_time" +"%s.%N"))))")

# 追加总时间到CSV文件
echo "Total Loading Time,$total_loading_time" >> "$csv_file"

echo "Data loading completed. Loading times recorded in $csv_file"
