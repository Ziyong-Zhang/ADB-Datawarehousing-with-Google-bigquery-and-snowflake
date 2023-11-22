import snowflake.connector
import time
import os
import csv

# calculate execution time
def execute_sql(connection, sql):
    cursor = connection.cursor()

    # Record start time
    start_time = time.time()

    # Execute SQL script
    cursor.execute(sql)

    # Record end time
    end_time = time.time()

    # Calculate execution time
    execution_time = end_time - start_time

    cursor.close()

    return execution_time

def execute_sql_files(connection, sql_directory, output_folder, num_runs):
    output_file_path = os.path.join(output_folder, 'execution_times.csv')

    with open(output_file_path, 'w', newline='') as csv_file:
        csv_writer = csv.writer(csv_file)
        header = ['Run Number', 'file_number', 'Execution Time (seconds)']
        csv_writer.writerow(header)

        for run in range(1, num_runs + 1):
            print(f"Run Number: {run}")
            for sql_file in os.listdir(sql_directory):
                if sql_file.endswith(".sql"):
                    with open(os.path.join(sql_directory, sql_file), 'r') as file:
                        sql_script = file.read()

                        # Extract numeric part from the beginning of the file name
                        file_number = ''.join(char for char in sql_file.split()[0] if char.isdigit())

                        # Execute the SQL script
                        execution_time = execute_sql(connection, sql_script)

                        # Write execution time to CSV file
                        csv_writer.writerow([run, file_number, execution_time])
                        print(f"{sql_file}: {execution_time} seconds")

    print(f"Execution times written to: {output_file_path}")

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

