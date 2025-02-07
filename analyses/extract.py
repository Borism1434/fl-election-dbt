import os 
def merge_txt_files():
    """ 
    prompts user for a directory, merge all .txt files within it into a single file, 
    and saves the output file indisde the same directory. 
    """
    try: 
        #ask the user for the directory path 
        directory = input("Enter the full path of the directory containing .txt files: ").strip()

        #validate if the directory exists 
        if not os.path.isdir(directory): 
            print("Error: The provided path is not a valid directory") 
            return
        
        # Get the directory name of naming the output file 
        directory_name = os.path.basename(os.path.normpath(directory)) 
        output_filename = os.path.join(directory, f"{directory_name}_combined_data.txt")

        #Initalize an empty list to store .txt filenames
        txt_files = []

        # Loop through files in the directory and collect .txt files
        for file_name in os.listdir(directory): 
            if file_name.endswith(".txt"):
                txt_files.append(file_name)
        
        # Check if there are any .txt files 
        if not txt_files:
            print("No .txt files found in the directory")
            return
        # Open the output file in write mode 
        with open (output_filename, "w", encoding="utf-8") as outfile:
            for txt_file in txt_files:
                file_path = os.path.join(directory,txt_file)

                # Open each text file and append its content 
                with open(file_path, "r", encoding="utf-8") as infile:
                    for line in infile:
                        outfile.write(line) # Write each line
                    outfile.write("\n") # add a newline for separation 
                print(f"Successfully merged {len(txt_files)} files into {output_filename}")
    except Exception as e :
        print(f"Error: {e}")

# Run the function
merge_txt_files()