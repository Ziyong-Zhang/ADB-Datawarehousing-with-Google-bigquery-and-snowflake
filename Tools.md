# Tools

<aside>
💡 Google BigQuery and Snowflake

</aside>

# TPC-H Data generate

- Data generating: [Manual_1_local](https://tedamoh.com/en/blog/55-data-modeling/78-generating-large-example-data-with-tpc-h)
- For `XXX.tbl` files, however, there is a bug in `dbgen` which generates an extra `|` at the end of each line. To fix it, run the following command:
- $ `for i in `ls *.tbl`; do sed 's/|$//' $i > ${i/tbl/csv}; echo $i; done;`

# Google BigQuery

<aside>
💡 ****新服务账号 HMAC 密钥****

hmac1-455@advanceddb-405622.iam.gserviceaccount.com

访问密钥GOOG1E6FKGZ5WLHO3NNSF77PBZCYPZPK2VED3LYQH3XIOL2YVJZPRNLBA3JDK

密钥
32A8aEifoLYJcF1XTofOhx5zcXEfVeJ0aFrPwtaA

</aside>

## Create Table

- 将csv文件的最后一列空列删除—》remove_null_col.py
- 将文件上传cloud storage
- 在sql console中创建表格—》big query中不支持primary key，结构类型的定义与snowflake也不同，进行修改
- 在cloud中用bp命令：
ziyongzhang01@cloudshell:~ (advanceddb-405622)$ bq load --noreplace --source_format=CSV PUBLIC.REGION gs://bucket_bdma_adb/TPC-H_05/region.csv

在database中创建表格：
$ ./create_table.sh TPCH_1G

使用以下命令一次性写入数据：
$ ./load_data.sh your_database_name
$ ./load_data.sh <your_database> <bucket_folder> TPC-H_05
以下命令修改sh文件：(ctrl+x 保存，enter 退出)
$ nano load_data.sh
以下命令让sh文件可执行：
$ chmod +x load_data.sh
- DATABASES:
PUBLIC
TPCH_1G
TPCH_2G
TPCH_3G
TPCH_5G

```bash
#!/bin/bash 
# 将数据从cloud storage中写入表格
# 检查是否提供了数据库名称
if [ -z "$1" ]; then
  echo "Usage: $0 <database_name>"
  exit 1
fi

project_id="advanceddb-405622"
database_name="$1"
datasets=("CUSTOMER" "LINEITEM" "NATION" "ORDERS" "PART" "PARTSUPP" "REGION" "SUPPLIER")

for dataset in "${datasets[@]}"
do
  lowercase_dataset=$(echo "$dataset" | tr '[:upper:]' '[:lower:]')
  bq load --noreplace --source_format=CSV ${project_id}:${database_name}.${dataset} gs://bucket_bdma_adb/TPC-H_05/${lowercase_dataset}.csv
done
```

```bash
#!/bin/bash
# chmod +x run_script.sh 
# ./run_script.sh your-dataset-name

# 项目 ID
project_id="your-project-id"
# 通过命令行参数传递的数据集名称
dataset_name="$1"
# Cloud Storage 中 SQL 文件的路径
sql_folder="gs://bucket_bdma_adb/queries_bq_general"
# 结果输出 CSV 文件路径
output_csv="output_runtimes_${dataset_name}.csv"
# 检查是否提供了数据集名称作为参数
if [ -z "$dataset_name" ]; then
  echo "Usage: $0 <dataset_name>"
  exit 1
fi
# 获取所有 SQL 文件列表
sql_files=$(gsutil ls ${sql_folder}/*.sql)
# 创建输出 CSV 文件并写入标题
echo "SQL_File,Run_Time" > ${output_csv}

# 循环遍历并执行每个 SQL 文件
for sql_file in ${sql_files[@]}
do
  # 提取表名（假设文件名为 table_name.sql）
  table_name=$(basename -- "${sql_file}")
  table_name="${table_name%.sql}"

  # 记录 SQL 文件名和执行时间的起始时间
  start_time=$(date +"%s")
  # 执行 SQL 文件
  bq query --use_legacy_sql=false --project_id=${project_id} --dataset_id=${dataset_name} < ${sql_file}
  # 记录运行时间
  end_time=$(date +"%s")
  run_time=$((end_time - start_time))
  # 输出结果到 CSV 文件
  echo "${table_name},${run_time}" >> ${output_csv}
done
```

## SQL 语句修改

```
`advanceddb-405622.PUBLIC.PART`,
	`advanceddb-405622.PUBLIC.SUPPLIER`,
	`advanceddb-405622.PUBLIC.PARTSUPP`,
	`advanceddb-405622.PUBLIC.NATION`,
	`advanceddb-405622.PUBLIC.REGION`,
	`advanceddb-405622.PUBLIC.CUSTOMER`,
	`advanceddb-405622.PUBLIC.LINEITEM`,
	`advanceddb-405622.PUBLIC.ORDERS`

`${PROJECT_ID}.${DATASET}.PART`,
	`${PROJECT_ID}.${DATASET}.SUPPLIER`,
	`${PROJECT_ID}.${DATASET}.PARTSUPP`,
	`${PROJECT_ID}.${DATASET}.NATION`,
	`${PROJECT_ID}.${DATASET}.REGION`,
	`${PROJECT_ID}.${DATASET}.CUSTOMER`,
	`${PROJECT_ID}.${DATASET}.LINEITEM`,
	`${PROJECT_ID}.${DATASET}.ORDERS`

```

```sql
-- 
-- 1
where
	l_shipdate <= DATEADD(DAY, 3, DATE '1998-12-01')
-- 改为
WHERE
    DATE(l_shipdate) <= DATE_ADD(DATE '1998-12-01', INTERVAL 3 DAY)

where
  DATE(PARSE_DATE('%m/%d/%Y',  l_shipdate)) <= DATE_ADD(DATE '1998-12-01', INTERVAL 3 DAY)

-- 13
-- The error you're encountering is due to the use of subqueries in the FROM clause, which is not supported in BigQuery. 
-- Instead, you can use a common table expression (CTE) to achieve the same result. Here's the modified query:
```

## 执行SQL语句

- run_main_script.py文件，在terminal中运行，参数为dataset_name.

# SNOWFLAKE

## Introduction

- Introduction reference: 介绍的文章与翻译博客 [paper](https://fuzhe1989.github.io/2020/12/28/the-snowflake-elastic-data-warehouse/)
- Problem: You can load data from individual files [up to 50 MB](https://docs.snowflake.com/en/user-guide/data-load-web-ui) in size.

## 数据生成

- terminal: dgen 命令生成tbl文件
- python: 用tbl_to_csv转换成csv文件
- terminal: 用put命令将文件上传到snowflake
- python: 建立stage，在schema中创建空表
- 将上传的文件写入空表中

## Upload data from local files

- - 创建外部存储区：[网站](https://docs.snowflake.com/en/sql-reference/sql/create-stage)
CREATE STAGE your_external_stage;
- - 上传数据文件到外部存储区
PUT file:///path/to/generated/data/*.tbl @your_external_stage;

## Python 自动执行文件

- 下载[snowflake connector for python](https://docs.snowflake.com/developer-guide/python-connector/python-connector)
- To install the latest Python Connector for Snowflake, use:
    - $ pip install snowflake-connector-python
- After configuring your driver, you can evaluate and troubleshoot your network connectivity to Snowflake using [SnowCD](https://docs.snowflake.com/en/user-guide/snowcd).
- Import the `snowflake.connector` module, execute the following command:
    - import snowflake.connector
- Connect using the default authenticator
    - account url: [https://wv59487.europe-west4.gcp.snowflakecomputing.com](https://wv59487.europe-west4.gcp.snowflakecomputing.com/)
	account identifier: wv59487.europe-west4.gcp
        
        organization: **TTUZQMN**
        
        account: **AE33915**
        
        locator: **WV59487**
        
        username: **ZIYONGZHANG**
        
        password: **Snowflake01#**
        
        warehouse: **COMPUTE_WH**
        
        database: 
        **SNOWFLAKE_SAMPLE_DATA
        ADB**
        
        schema: **PUBLIC , TPCH_1 , TPCH_2 , TPCH_3**
        
        conn = snowflake.connector.connect(
        user=USER,
        password=PASSWORD,
        account=ACCOUNT_url,
        warehouse=WAREHOUSE,
        database=DATABASE,
        schema=SCHEMA
        )
        
        -a wv59487.europe-west4.gcp -u **ZIYONGZHANG -d ADB -s PUBLIC** 
        
    - sql_directory: /Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3.0.1/dbgen/queries_test
    - Create table:
    /Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/scripts/Create_table/create_table.sql
    - Terminal:
    $ snowsql -a wv59487.europe-west4.gcp -u ZIYONGZHANG -d ADB -s PUBLIC
    $

## SQL 修改

- 修改语句
    
    SQL_1
    where
    l_shipdate <= DATEADD(DAY, 3, DATE '1998-12-01')
    
    SQL_2
    and p_size = 8
    and p_type like '%BRASS'
    and r_name = 'EUROPE’
    
    SQL_3
    c_mktsegment = 'BUILDING'
    and c_custkey = o_custkey
    and l_orderkey = o_orderkey
    and o_orderdate < date '1994-06-13'
    and l_shipdate > date '1994-09-30'
    
    SQL_4
    where
    o_orderdate >= date '1997-11-11'
    and o_orderdate < DATEADD(MONTH, 3, DATE'1997-11-11')
    
    SQL_7
    and p_type = 'STANDARD ANODIZED BRASS’
    
    SQL_12
    and l_shipmode in ('FOB', 'TRUCK') 
    and l_receiptdate >= date '1995-01-01'
    and l_receiptdate < DATEADD(YEAR, 1, date '1995-01-01')
    
    SQL_15
    ERROR—>SQL execution error: Creating view on shared database 'SNOWFLAKE_SAMPLE_DATA' is not allowed.
    
    SQL_19 
    and p_brand = 'Brand#31'
    
    SQL_22
    SUBSTRING(c_phone FROM 1 FOR 2)—>SUBSTRING(c_phone,1,2)
    

<aside>
💡

</aside>
