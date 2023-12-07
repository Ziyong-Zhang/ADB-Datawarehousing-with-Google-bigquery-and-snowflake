import snowflake.connector
import time

def execute_insert_query(connection, query, output_file):
    start_time = time.time()
    
    cursor = connection.cursor()
    cursor.execute(query)
    
    end_time = time.time()
    execution_time = end_time - start_time
    
    cursor.close()
    
    with open(output_file, 'a') as file:
        file.write(f"Execution time for query '{query}': {execution_time} seconds\n")

# Snowflake连接信息
username = 'ZIYONGZHANG'
password = 'Snowflake01#'
account = 'wv59487.europe-west4.gcp'
warehouse = 'COMPUTE_WH'
database = 'ADB'
schema = input("Enter Snowflake schema: ")

# Snowflake连接
conn = snowflake.connector.connect(
    user=username,
    password=password,
    account=account,
    warehouse=warehouse,
    database=database,
    schema=schema
)

# SQL查询
delete_query_1 ="delete from LINEITEM where L_ORDERKEY in (select O_ORDERKEY from delete_orders);"
delete_query_2 ="delete from ORDERS where O_ORDERKEY in (select O_ORDERKEY from delete_orders);"

# 执行查询并记录执行时间
output_folder = '/home/echo/Desktop/SnowF/RF2/'

execute_insert_query(conn, delete_query_1, output_folder + 'execution_times.txt')
execute_insert_query(conn, delete_query_2, output_folder + 'execution_times.txt')


# 关闭连接
conn.close()

