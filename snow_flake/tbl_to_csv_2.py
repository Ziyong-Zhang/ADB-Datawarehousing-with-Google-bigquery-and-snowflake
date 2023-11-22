import os
import csv

def convert_tbl_to_csv(input_folder, output_folder):
    # Ensure the output folder exists
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Loop through each file in the input folder
    for filename in os.listdir(input_folder):
        if filename.endswith(".tbl"):
            input_file_path = os.path.join(input_folder, filename)
            output_file_path = os.path.join(output_folder, f"{os.path.splitext(filename)[0]}.csv")

            with open(input_file_path, 'r') as tbl_file, open(output_file_path, 'w', newline='') as csv_file:
                tbl_reader = csv.reader(tbl_file, delimiter='|')
                csv_writer = csv.writer(csv_file)

                for row in tbl_reader:
                    # Replace the trailing '|' with a space in each cell
                    cleaned_row = [cell.rstrip('|') for cell in row]
                    csv_writer.writerow(cleaned_row)

if __name__ == "__main__":
    input_folders = [
        '/Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/dbgen/tbl_tpc-h_05'
        # '/Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/dbgen/tbl_tpc-h_1g',
        # '/Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/dbgen/tbl_tpc-h_2g',
        # '/Users/zzy13/Desktop/Classes_at_ULB/Advanced_Databases_415/Project/TPC-H_V3_0_1/dbgen/tbl_tpc-h_3g',
    ]

    for input_folder in input_folders:
        # Extract the folder name (e.g., TPC-H-1G) to use in the output folder path
        folder_name = os.path.basename(input_folder)

        # Perform the conversion for the current input folder
        convert_tbl_to_csv(input_folder, input_folder)
