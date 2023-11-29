# terminal
# python through_put.py TPCH_1G --concurrent_users 16

import snowflake.connector
import time
import os
import csv
import concurrent.futures
import argparse


# Snowflake 连接函数
def create_snowflake_connection(username, password, account, warehouse, database, schema):
    snowflake_params = {
        'user': username,
        'password': password,
        'account': account,
        'warehouse': warehouse,
        'database': database,
        'schema': schema,
    }

    return snowflake.connector.connect(**snowflake_params)

# 计算执行时间函数
def execute_sql(connection, sql, user_id, run_number, file_number):
    cursor = connection.cursor()

    # 记录开始时间
    start_time = time.time()

    # 执行 SQL 脚本
    cursor.execute(sql)

    # 记录结束时间
    end_time = time.time()

    # 计算执行时间
    execution_time = end_time - start_time

    cursor.close()

    # 返回包括 user_id, run_number, file_number, execution_time 的元组
    return user_id, run_number, file_number, execution_time


# 执行 SQL 文件函数
def execute_sql_files(user_id, connection, sql_directory, csv_writer, run_number):
    for sql_file in os.listdir(sql_directory):
        if sql_file.endswith(".sql"):
            with open(os.path.join(sql_directory, sql_file), 'r') as file:
                sql_script = file.read()

                # 从文件名中提取数字部分
                file_number = ''.join(char for char in sql_file.split()[0] if char.isdigit())

                # 使用 user_id, run_number, file_number 执行 SQL 脚本
                print(f"Run Number: {run_number}, User_ID: {user_id}")
                result = execute_sql(connection, sql_script, user_id, run_number, file_number)

                # 将执行时间写入 CSV 文件
                csv_writer.writerow(result)

    print(f"Execution times written to CSV file")

if __name__ == "__main__":
    USERNAME = 'ZIYONGZHANG'
    PASSWORD = 'Snowflake01#'
    ACCOUNT = 'wv59487.europe-west4.gcp'
    WAREHOUSE = 'COMPUTE_WH'
    DATABASE = 'ADB'
    parser = argparse.ArgumentParser(description='Run Snowflake queries with concurrent users.')
    parser.add_argument('schema', type=str, help='Name of the schema')
    parser.add_argument('--concurrent_users', type=int, default=4, help='Number of concurrent users')
    args = parser.parse_args()

    # 输入 Snowflake 连接参数等信息
    connections = [create_snowflake_connection(USERNAME, PASSWORD, ACCOUNT, WAREHOUSE, DATABASE, args.schema) for _ in range(args.concurrent_users)]

    # SQL 文件夹路径
    sql_directory = '/Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/dbgen/queries_test'
    
    # 输出文件夹路径
    output_folder = os.path.join(sql_directory, f'Throughput_time_cu{args.concurrent_users}', args.schema)

    # 创建输出文件夹
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # 打开一个 CSV 文件，用于写入所有运行时间
    output_file_path = os.path.join(output_folder, 'execution_times_all.csv')
    with open(output_file_path, 'w', newline='') as csv_file:
        csv_writer = csv.writer(csv_file)
        header = ['User_ID', 'Run_Number', 'File_Number', 'Execution_Time_sec']
        csv_writer.writerow(header)

        # 循环执行多次并发查询
        for run_number in range(1, 7):
            # 使用 ThreadPoolExecutor 启动多个查询任务
            with concurrent.futures.ThreadPoolExecutor(max_workers=args.concurrent_users) as executor:
                # 启动多个查询任务
                futures = [executor.submit(
                    execute_sql_files,
                    user_id,
                    connection,
                    sql_directory,
                    csv_writer,
                    run_number
                ) for user_id, connection in enumerate(connections, start=1)]

    # 关闭所有连接
    for connection in connections:
        connection.close()