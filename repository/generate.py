# Python program to transform each line of a text file and write to a new file

def transform_line(line):
    line = line.strip()  # Remove any leading/trailing whitespace
    return f"Instruction <= 32'h{line};"

def process_file(input_file, output_file):
    with open(input_file, 'r') as infile:
        lines = infile.readlines()

    with open(output_file, 'w') as outfile:
        for i, line in enumerate(lines):
            transformed_line = transform_line(line)
            # Format the line with the appropriate address index (assuming starting from 207)
            address = i
            outfile.write(f"9'd{address}: {transformed_line}\n")

# File paths
input_file = 'input.txt'
output_file = 'output.txt'

# Process the files
process_file(input_file, output_file)
