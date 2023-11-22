import os
import pandas as pd

def remove_last_null_column(csv_file_path):
    # Read the CSV file into a DataFrame
    df = pd.read_csv(csv_file_path)

    # Check if the last column is all null
    last_column = df.columns[-1]
    if df[last_column].isnull().all():
        # Remove the last column
        df = df.iloc[:, :-1]

        # Write the modified DataFrame back to the CSV file
        df.to_csv(csv_file_path, index=False)

if __name__ == "__main__":
    input_folders = [
        '/Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/dbgen/TPC-H_05',
        '/Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/dbgen/TPC-H-1G',
        '/Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/dbgen/TPC-H-2G',
        '/Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/dbgen/TPC-H-3G',
        '/Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/dbgen/TPC-H-5G',
    ]

    for folder_path in input_folders:
        # Loop through each CSV file in the folder
        for filename in os.listdir(folder_path):
            if filename.endswith(".csv"):
                file_path = os.path.join(folder_path, filename)
                remove_last_null_column(file_path)