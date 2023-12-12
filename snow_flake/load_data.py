from snowflake_utils import create_snowflake_connection
import os
import time
import csv 

def exe_single_sql(connection, sql_script):
    cursor = connection.cursor()
    # Split the SQL script into individual statements
    statements = sql_script.split(';')

    # Execute each statement
    for statement in statements:
        if statement.strip():  # Skip empty statements
            cursor.execute(statement)

def copy_csv_to_table(connection, table_name, stage_name):
    start_time = time.time()  # 记录开始时间

    copy_query = f"""
        COPY INTO {table_name}
        FROM @{stage_name}/{table_name.lower()}.csv
        FILE_FORMAT = (TYPE = 'CSV' error_on_column_count_mismatch=false)
        ON_ERROR = 'CONTINUE';
    """
    connection.cursor().execute(copy_query)
    end_time = time.time()  # 记录结束时间
    loading_time = round(end_time - start_time, 3)  # 计算加载时间
    return loading_time

if __name__ == "__main__":
    # Input Snowflake connection parameters
    username = 'ZIYONGZHANG'
    password = 'Snowflake01#'
    account = 'wv59487.europe-west4.gcp'
    warehouse = 'COMPUTE_WH'
    # database = input("Input your database name:")
    database = 'ADB'
    schema = input("Input your schema:")
    stage_name = input("Input the stage name:")
    sql_script = """
    
    DROP TABLE IF EXISTS PART ;
    CREATE TABLE PART (
    
        P_PARTKEY		INTEGER PRIMARY KEY,
        P_NAME			VARCHAR(55),
        P_MFGR			CHAR(25),
        P_BRAND			CHAR(10),
        P_TYPE			VARCHAR(25),
        P_SIZE			INTEGER,
        P_CONTAINER		CHAR(10),
        P_RETAILPRICE	DECIMAL,
        P_COMMENT		VARCHAR(23)
    );
    
    DROP TABLE  IF EXISTS SUPPLIER;
    CREATE TABLE SUPPLIER (
        S_SUPPKEY		INTEGER PRIMARY KEY,
        S_NAME			CHAR(25),
        S_ADDRESS		VARCHAR(40),
        S_NATIONKEY		INTEGER NOT NULL, -- references N_NATIONKEY
        S_PHONE			CHAR(15),
        S_ACCTBAL		DECIMAL,
        S_COMMENT		VARCHAR(101)
    );
    
    DROP TABLE  IF EXISTS PARTSUPP;
    CREATE TABLE PARTSUPP (
        PS_PARTKEY		INTEGER NOT NULL, -- references P_PARTKEY
        PS_SUPPKEY		INTEGER NOT NULL, -- references S_SUPPKEY
        PS_AVAILQTY		INTEGER,
        PS_SUPPLYCOST	DECIMAL,
        PS_COMMENT		VARCHAR(199),
        PRIMARY KEY (PS_PARTKEY, PS_SUPPKEY)
    );
    
    DROP TABLE  IF EXISTS CUSTOMER;
    CREATE TABLE CUSTOMER (
        C_CUSTKEY		INTEGER PRIMARY KEY,
        C_NAME			VARCHAR(25),
        C_ADDRESS		VARCHAR(40),
        C_NATIONKEY		INTEGER NOT NULL, -- references N_NATIONKEY
        C_PHONE			CHAR(15),
        C_ACCTBAL		DECIMAL,
        C_MKTSEGMENT	CHAR(10),
        C_COMMENT		VARCHAR(117)
    );
    
    DROP TABLE  IF EXISTS ORDERS;
    CREATE TABLE ORDERS (
        O_ORDERKEY		INTEGER PRIMARY KEY,
        O_CUSTKEY		INTEGER NOT NULL, -- references C_CUSTKEY
        O_ORDERSTATUS	CHAR(1),
        O_TOTALPRICE	DECIMAL,
        O_ORDERDATE		DATE,
        O_ORDERPRIORITY	CHAR(15),
        O_CLERK			CHAR(15),
        O_SHIPPRIORITY	INTEGER,
        O_COMMENT		VARCHAR(79)
    );
    
     DROP TABLE  IF EXISTS LINEITEM;
     CREATE TABLE LINEITEM (
        L_ORDERKEY		INTEGER NOT NULL, -- references O_ORDERKEY
        L_PARTKEY		INTEGER NOT NULL, -- references P_PARTKEY (compound fk to PARTSUPP)
        L_SUPPKEY		INTEGER NOT NULL, -- references S_SUPPKEY (compound fk to PARTSUPP)
        L_LINENUMBER	INTEGER,
        L_QUANTITY		DECIMAL,
        L_EXTENDEDPRICE	DECIMAL,
        L_DISCOUNT		DECIMAL,
        L_TAX			DECIMAL,
        L_RETURNFLAG	CHAR(1),
        L_LINESTATUS	CHAR(1),        
        L_SHIPDATE		DATE,
        L_COMMITDATE	DATE,
        L_RECEIPTDATE	DATE,
        L_SHIPINSTRUCT	CHAR(25),
        L_SHIPMODE		CHAR(10),
        L_COMMENT		VARCHAR(44),

        PRIMARY KEY (L_ORDERKEY, L_LINENUMBER)
     );
    
    DROP TABLE  IF EXISTS NATION;
    CREATE TABLE NATION (
        N_NATIONKEY		INTEGER PRIMARY KEY,
        N_NAME			CHAR(25),
        N_REGIONKEY		INTEGER NOT NULL,  -- references R_REGIONKEY
        N_COMMENT		VARCHAR(152)
    );
    
    DROP TABLE  IF EXISTS REGION;
    CREATE TABLE REGION (
        R_REGIONKEY	INTEGER PRIMARY KEY,
        R_NAME		CHAR(25),
        R_COMMENT	VARCHAR(152)
    );
    """
    # Create Snowflake connection
    connection = create_snowflake_connection(username, password, account, warehouse, database, schema)
    exe_single_sql(connection,sql_script)
    # List of table names
    table_names = ['CUSTOMER', 'LINEITEM', 'NATION', 'ORDERS', 'PART', 'PARTSUPP', 'REGION', 'SUPPLIER']
    # for table_name in table_names:
    #     copy_csv_to_table(connection, table_name, stage_name)
    
    csv_file = "loading_times.csv"
    with open(csv_file, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['Table Name', 'Loading Time'])  # Write column headers

        total_loading_time = 0

        for table_name in table_names:
            loading_time = copy_csv_to_table(connection, table_name, stage_name)
            writer.writerow([table_name, loading_time])
            total_loading_time += loading_time

        # Write total loading time in the last row
        writer.writerow(['Total Loading Time', round(total_loading_time, 3)])

    # Close the connection
    connection.close()