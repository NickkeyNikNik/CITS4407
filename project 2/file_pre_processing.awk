#!/usr/bin/awk -f

# This AWK script processes tab-separated files to check the format, identify specific data patterns,
# and conditionally manipulate and output data based on the contents of specific fields.

BEGIN {
    # Set the field separator to tab for input and output.
    FS = "\t"
    OFS = "\t"
    start = 9999  # Initialize start to a high value to find the minimum in later comparisons.
    end = 0       # Initialize end to zero to find the maximum in later comparisons.
}

# Process the header line of the file.
NR == 1 {
    # Check if the first line (header) contains tabs as field separators and has more than one field.
    if (NF < 2) {
        print "Error: The file is not in tab-separated format."
        exit 1  # Exit if file format is incorrect with an error message.
    } else {
        num_cells = NF  # Store the number of cells in the header line.
    }
}

# This block manipulates the number of fields under certain conditions and finds the index of a specific column.
NF {
    # If the number of fields is greater than 4, reduce the field count by one.
    if (NF > 4) {
        NF -= 1
    }

    # Loop through all fields to find the column index of "Cantril ladder score".
    for (i = 1; i <= NF; i++) {
        if ($i == "Cantril ladder score") {
            cantril_index = i  # Store the index of the "Cantril ladder score".
            break
        }
    }
}

# Process each record after the header.
NR {
    # Reprint the header line with appropriate tab separation.
    if (NR == 1) {
        for (i=1; i<=NF; i++) {
            printf "%s", $i;
            if (i < NF) printf "\t";  # Ensure tab only prints between fields, not at line end.
        }
        printf "\n"
    }

    # Skip lines with exactly 4 fields where the second field is empty.
    if (NF == 4 && $2 == "") {
        next
    } 
    # For lines with exactly 6 fields, track the minimum and maximum year values in the "Cantril ladder score" column.
    else if (NF == 6 && $cantril_index != "") {
        if ($3 <= start) {
            start = $3  # Update start year to the lower value found.
        } else if ($3 >= end) {
            end = $3    # Update end year to the higher value found.
        }
    }
    records[NR] = $0  # Store the entire record in an array for later processing.
}





END {
    # Process records for files with exactly 4 fields.
    if (NF == 4) {
        for (i = 2; i <= NR; i++) {
            if (records[i] == "") {
                continue
            }
            if (fields[2] == "") {
                print records[i]
            }
        }
    }
    # Process records for files with exactly 6 fields.
    else if (NF == 6) {
        for (i = 2; i <= NR; i++) {
            split(records[i], fields, FS)
            # Print records where the "Cantril ladder score" is between the start and end values
            # and the second field is not empty.
            if (fields[3] >= start && fields[3] <= end && fields[2] != "") { 
                print records[i]
            }
        }
    }
}
