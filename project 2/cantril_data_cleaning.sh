#!/usr/bin/env bash
#
# Project 2
# Name: Nicodemus Ong
# Student ID: 22607943
# This script processes three .tsv files to check their format, sort them, and join them to create a unified output.
# It then formats the final result and cleans up intermediate files.

# Function to check if a file exists and is not empty.
check_file() {
  if [[ ! -s "$1" ]]; then
    echo "Error: $1 is missing or empty." > /dev/stderr
    exit 1
  fi
}

# Function to check if a command was successful.
check_success() {
  if [[ $? -ne 0 ]]; then
    echo "Error: $1 failed." > /dev/stderr
    exit 1
  fi
}

# Check if exactly three arguments are provided. If not, print the usage information and exit with status 1.
if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <.tsv File (1)> <.tsv File (2)> <.tsv File (3)>" > /dev/stderr
  exit 1
fi

# Check if the input files exist and are not empty.
for file in "$1" "$2" "$3"; do
  check_file "$file"
done

# Process each input .tsv file to check its format and cells using an AWK script.
gawk -f file_format_check.awk "$1" > /dev/stderr
check_success "File format check for $1"

gawk -f file_format_check.awk "$2" > /dev/stderr
check_success "File format check for $2"

gawk -f file_format_check.awk "$3" > /dev/stderr
check_success "File format check for $3"

# Process each input .tsv file to process its format using an AWK script and output the results to new files.
gawk -f file_pre_processing.awk "$1" > file1.tsv
check_success "File pre-processing for $1"

gawk -f file_pre_processing.awk "$2" > file2.tsv
check_success "File pre-processing for $2"

gawk -f file_pre_processing.awk "$3" > file3.tsv
check_success "File pre-processing for $3"

# Check if the pre-processed files were created successfully.
for file in file1.tsv file2.tsv file3.tsv; do
  check_file "$file"
done

# Sort each of the checked files using a separate sorting script and output the sorted results to new files.
./sort.sh file1.tsv > key_file1.tsv
check_success "Sorting file1.tsv"
check_file key_file1.tsv

./sort.sh file2.tsv > key_file2.tsv
check_success "Sorting file2.tsv"
check_file key_file2.tsv

./sort.sh file3.tsv > key_file3.tsv
check_success "Sorting file3.tsv"
check_file key_file3.tsv

# Join the first two sorted files on their first column and output to a temporary file.
join -t $'\t' -1 1 -2 1 key_file1.tsv key_file2.tsv > tmp.tsv
check_success "Joining key_file1.tsv and key_file2.tsv"
check_file tmp.tsv

# Join the third sorted file with the temporary file from the previous join,
# effectively merging all three files based on their first columns.
join -t $'\t' -1 1 -2 1 key_file3.tsv tmp.tsv > output.tsv
check_success "Joining key_file3.tsv and tmp.tsv"
check_file output.tsv

# Format the final joined results using another AWK script and output to the final results file.
gawk -f results_format.awk output.tsv

# Remove all intermediate files to clean up the working directory.
rm -f key_file1.tsv key_file2.tsv key_file3.tsv tmp.tsv output.tsv
