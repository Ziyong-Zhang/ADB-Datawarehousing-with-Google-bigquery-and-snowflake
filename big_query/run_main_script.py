from google.cloud import bigquery
import os
import time
import csv
import sys

# Service Account authentication credentials for your BigQuery account (we have deleted our json file for safety, you may replace it with your own credentials file)
AUTH_JSON_FILE_PATH = '/Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/scripts/big_query/advanceddb.json'
# BigQuery project ID
PROJECT_ID = 'advanceddb-405622'
# SQL folder path
SQL_FOLDER_PATH = '/Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/dbgen/queries_test_bq/queries_bq_general'

# get the parameters
if len(sys.argv) != 2:
    print("Usage: python your_script.py <dataset_name>")
    sys.exit(1)
dataset_name = sys.argv[1]

# output CSV file path
output_folder = os.path.join(SQL_FOLDER_PATH,'Execution_time', f'{dataset_name}')
os.makedirs(output_folder, exist_ok=True)
OUTPUT_CSV_PATH = os.path.join(output_folder, 'execution_times.csv')

# get all the SQL files
sql_files = [os.path.join(SQL_FOLDER_PATH, file) for file in os.listdir(SQL_FOLDER_PATH) if file.endswith(".sql")]


# write CSV 
with open(OUTPUT_CSV_PATH, 'w', newline='') as csvfile:
    csv_writer = csv.writer(csvfile)
    csv_writer.writerow(['Run_Number','SQL_File', 'Run_Time'])

# initialize BigQuery 
client = bigquery.Client.from_service_account_json(AUTH_JSON_FILE_PATH)

# loop for every SQL file
for sql_file in sql_files:
    # get the file name
    table_name = os.path.basename(sql_file).replace('.sql', '')

    # replace the dataset_name in SQL file
    with open(sql_file, 'r') as file:
        sql_content = file.read()
        sql_content = sql_content.replace('${PROJECT_ID}', PROJECT_ID)
        # replace dataset_name, e.g. 'PUBLIC'
        sql_content = sql_content.replace('${DATASET}', dataset_name)

    # loop for 6 times
    for run_number in range(1, 7):
        # record SQL file name, execution time 
        start_time = time.time()

        # execute BigQuery 
        query_job = client.query(sql_content)

        query_job.result()

        # execution time calculation
        end_time = time.time()
        run_time = end_time - start_time

        # add to CSV file
        with open(OUTPUT_CSV_PATH, 'a', newline='') as csvfile:
            csv_writer = csv.writer(csvfile)
            csv_writer.writerow([run_number, table_name, run_time])
