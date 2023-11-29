# terminal:
# python your_script.py your_dataset_name --concurrent_users 4

from google.cloud import bigquery
import os
import time
import csv
import concurrent.futures
import argparse

# 认证文件路径
AUTH_JSON_FILE_PATH = '/Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/scripts/big_query/advanceddb.json'
# BigQuery 项目 ID
PROJECT_ID = 'advanceddb-405622'
# SQL 文件夹路径
SQL_FOLDER_PATH = '/Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/dbgen/queries_test_bq/queries_bq_general'

# 在脚本中添加以下代码以获取命令行参数
parser = argparse.ArgumentParser(description='Run BigQuery queries with concurrent users.')
parser.add_argument('dataset_name', type=str, help='Name of the dataset')
parser.add_argument('--concurrent_users', type=int, default=4, help='Number of concurrent users')

args = parser.parse_args()

# 输出 CSV 文件路径
output_folder = os.path.join(SQL_FOLDER_PATH, f'Throughput_time_cu{args.concurrent_users}', f'{args.dataset_name}')
os.makedirs(output_folder, exist_ok=True)
OUTPUT_CSV_PATH = os.path.join(output_folder, 'execution_times.csv')

# 获取所有 SQL 文件列表
sql_files = [os.path.join(SQL_FOLDER_PATH, file) for file in os.listdir(SQL_FOLDER_PATH) if file.endswith(".sql")]

# 写入 CSV 文件头
with open(OUTPUT_CSV_PATH, 'w', newline='') as csvfile:
    csv_writer = csv.writer(csvfile)
    csv_writer.writerow(['User_ID', 'Run_Number', 'SQL_File', 'Run_Time'])

# 初始化 BigQuery 客户端
client = bigquery.Client.from_service_account_json(AUTH_JSON_FILE_PATH)

# Snowflake查询函数
def run_query(user_id, run_number, table_name, sql_content):
    # 记录 SQL 文件名、执行时间和运行次数的起始时间
    start_time = time.time()

    # 执行 BigQuery 查询
    query_job = client.query(sql_content)

    # 等待查询完成
    query_job.result()

    # 计算运行时间
    end_time = time.time()
    run_time = end_time - start_time

    # 追加运行时间和运行次数到 CSV 文件
    with open(OUTPUT_CSV_PATH, 'a', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)
        csv_writer.writerow([user_id, run_number, table_name, run_time])

# 外部循环添加 run_number，启动并发查询
for run_number in range(1, 7):
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.concurrent_users) as executor:
        for sql_file in sql_files:
            # 提取表名
            table_name = os.path.basename(sql_file).replace('.sql', '')

            # 替换 SQL 文件中的占位符
            with open(sql_file, 'r') as file:
                sql_content = file.read()
                sql_content = sql_content.replace('${PROJECT_ID}', PROJECT_ID)
                # 这里将 dataset_name 替换为你的输入值，例如 'PUBLIC'
                sql_content = sql_content.replace('${DATASET}', args.dataset_name)

            # 启动多个查询任务
            futures = [executor.submit(run_query, user_id, run_number, table_name, sql_content) for user_id in range(1, args.concurrent_users + 1)]

            # 等待所有任务完成
            concurrent.futures.wait(futures)
