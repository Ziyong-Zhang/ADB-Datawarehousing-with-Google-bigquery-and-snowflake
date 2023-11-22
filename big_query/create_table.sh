#!/bin/bash

# 项目 ID
project_id="advanceddb-405622"

# 获取命令行参数中的数据集列表
datasets=("$@")

# 检查是否提供了数据集列表
if [ "${#datasets[@]}" -eq 0 ]; then
  echo "Usage: $0 <dataset1> <dataset2> ..."
  exit 1
fi

# SQL 模板文件路径
sql_template="create_tables_template.sql"

# 循环遍历数据集并在每个数据集中执行 SQL 文件
for dataset in "${datasets[@]}"
do
  # 替换 SQL 模板文件中的项目 ID 和数据集名称
  sed -e "s/\${PROJECT_ID}/${project_id}/g" -e "s/\${DATASET}/${dataset}/g" "${sql_template}" > "${dataset}_create_tables.sql"

  # 执行 SQL 文件
  bq query --use_legacy_sql=false < "${dataset}_create_tables.sql"

  # 删除生成的 SQL 文件
  rm "${dataset}_create_tables.sql"
done

