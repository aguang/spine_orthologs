#!/bin/bash
# modified from chatgpt
# Usage: count_and_write_samples.sh ${INPUT_DIR} ${ID}

# Exit on error
set -e

# Variables
INPUT_DIR=$1   # Folder containing paired files
ID=$2 # id to write to
OUTPUT_FILE=${INPUT_DIR}/"${ID}_samples_file.tsv"

# Check if input directory is provided and exists
if [[ -z "$INPUT_DIR" || ! -d "$INPUT_DIR" ]]; then
    echo "Usage: $0 <input_directory>"
    exit 1
fi

# Find all R1 files and match them with their R2 pairs
rep_count=1  # Initialize replicate counter

for file1 in $(find "$INPUT_DIR" -type f -name "*_1.fastq.gz" | sort); do
#    echo ${file1}
    # Construct the R2 file path by replacing _R1 with _R2
    file2=${file1/_R1.fastq.gz/_R2.fastq.gz}

    # Check if both pairs exist
    if [[ -f "$file2" ]]; then
        # Write the result to the output file
        echo -e "A\trep${rep_count}\t${file1}\t${file2}" >> $OUTPUT_FILE
        ((rep_count++))  # Increment the replicate counter
    else
        echo "Warning: Missing pair for ${file1}" >&2
    fi
done

echo "Paired files list saved to $OUTPUT_FILE"
