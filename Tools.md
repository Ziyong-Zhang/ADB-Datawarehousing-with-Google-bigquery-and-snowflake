# Tools

<aside>
💡 Google BigQuery and Snowflake

</aside>

# TPC-H Data generate

- Data generating: dgen command
- For `XXX.tbl` files, however, there is a bug in `dbgen` which generates an extra `|` at the end of each line. To fix it, run the following command:
- $ `for i in `ls *.tbl`; do sed 's/|$//' $i > ${i/tbl/csv}; echo $i; done;`

# Google BigQuery

<aside>
💡 You need to apply for a Google BigQuery account and have a subscription to get full access to the functions.

</aside>

## Create Table

- Delete the final null column of the csv files: remove_null_col.py
- Update .csv files to Google Cloud Storage.
- Create null tables using BigQuery Console: BigQuery does not support primary key, the definition of some datatype is different from the original ones, which requires modification.
- Using bq command to create table and load data in BigQuery Console:
username@cloudshell:~ (project id)$ bq load --noreplace --source_format=CSV your_database_name.table_name gs://your/path/to/bucket/in/cloud/storage

Create tables in database:
$ ./create_table.sh your_database_name

Use the following command to write data in one go:
$ ./load_data.sh your_database_name
$ ./load_data.sh <your_database> <bucket_folder> 
Use the following command to save .sh file：(ctrl+x: save，enter: exit)
$ nano load_data.sh
Use the following command to make .sh file executable：
$ chmod +x load_data.sh
- DATABASES:
PUBLIC
TPCH_1G
TPCH_2G
TPCH_3G

## DDL Modification

Shown as the report.

## SQL Query Modification

Shown as the report.

## Running SQL Query

- Use .json file to connect to the Google BigQuery in local environment.
- Run run_main_script.py file within local terminal, with parameter your_dataset_name.

# SNOWFLAKE

💡 You need to apply for a Snowflake account and have a subscription to get full access to the functions.

## Introduction

Shown as report.

## Data Generation

- terminal: dgen command
- python: use tbl_to_csv.py to turn .tbl as .csv files
- terminal: use **put** command in local terminal to upload datasets into Snowflake
- python: create Stage in Snowflake, create empty tables in schema
- Load data in the files to the empty tables

## Upload data from local files

- - Create Stage in Snowflake: [Reference](https://docs.snowflake.com/en/sql-reference/sql/create-stage)
CREATE STAGE your_stage;
- - Upload data files into stage:
PUT file:///path/to/generated/data/*.tbl @your_stage;

## Python Local Connector

- Download [snowflake connector for python](https://docs.snowflake.com/developer-guide/python-connector/python-connector)
- To install the latest Python Connector for Snowflake, use:
    - $ pip install snowflake-connector-python
- After configuring your driver, you can evaluate and troubleshoot your network connectivity to Snowflake using [SnowCD](https://docs.snowflake.com/en/user-guide/snowcd).
- Import the `snowflake.connector` module, execute the following command:
    - import snowflake.connector
- Connect using the default authenticator
    - account url: https://your_account_identifier.snowflakecomputing.com
	account identifier: **your_account_identifier**
        organization: **your_account_organization**
        account: **your_account**
        locator: **your_locator**
        username: **your_user_name**
        password: **your_pwd**
        warehouse: **your_wh**
        database: **your_database**
        schema: **your_schema_1 , your_schema_2 , your_schema_3 , your_schema_4**
        
        conn = snowflake.connector.connect(
        user=USER,
        password=PASSWORD,
        account=ACCOUNT_url,
        warehouse=WAREHOUSE,
        database=DATABASE,
        schema=SCHEMA
        )
        
    - Create table: /path/to/your_sql_directory/create_table.sql
    - Terminal:
    $ snowsql -a <your_account_identifier> -u <your_user_name> -d <your_database> -s <your_schema_name>
    
## SQL Modification

Shown as the report.
