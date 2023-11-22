# main_script.py

from snowflake_utils import execute_sql_files, create_snowflake_connection
import os

if __name__ == "__main__":
    # Input Snowflake connection parameters
    username = 'ZIYONGZHANG'
    password = 'Snowflake01#'
    account = 'wv59487.europe-west4.gcp'
    warehouse = 'COMPUTE_WH'
    database = 'ADB'
    schema = input("Enter Snowflake schema: ")

    # Directory containing SQL files
    sql_directory = '/Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/dbgen/queries_test'
    # Derive the output folder path based on the schema
    output_folder = os.path.join(sql_directory, 'Execution_time', schema)

    # Create the output folder if it doesn't exist
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    num_runs = 6

    # Create Snowflake connection
    connection = create_snowflake_connection(username, password, account, warehouse, database, schema)

    # Execute SQL files
    execute_sql_files(connection, sql_directory, output_folder, num_runs)

    # Close the connection
    connection.close()
