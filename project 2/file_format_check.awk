#!/usr/bin/awk -f

# This AWK script looks at tab-separated files to check the format, identify errors in data lines,
# and reports them.

BEGIN {
    FS = "\t"  # Set field separator to tab
}

# Process the first line only
NR == 1 {
    # Check if the first line contains tabs as field separators
    if (NF < 2) {
        print "Error: The file is not in tab-separated format."
        exit 1
    } 
    else {
        num_cells = NF   # Store the number of cells in the header line
    }
}

NR > 1 {
    # Check if the number of cells in the current line is not equal to the number of cells in the header line
    if (NF != num_cells) {
        records[NR] = sprintf("Error: Line %d does not have the same number of cells as the header line.", NR)
    }
}


END {
    if (length(records) > 0) {
        print FILENAME "File has these lines with missing cells:"

        for (i = 1; i <= length(records); i++) {
            if (records[i] == "") {
                continue
            }
            print records[i]
        }
    }
}