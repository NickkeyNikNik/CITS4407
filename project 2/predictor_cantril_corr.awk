#!/usr/bin/awk -f

# This AWK script processes tab-separated values to calculate the correlation between different variables
# based on user-specified options. It outputs the correlation coefficient for each country.

BEGIN {
    FS = "\t"     # Sets the field separator for the input files to tabs.
    OFS = "\t"    # Sets the output field separator to tabs.
    n = 1         # Initialize counter for country indexing.

    # Default x index is set to 5, used to select the default column for comparison if no option is given or an incorrect one.
    x_index = 5

    if (option == "l") {
        x_index = 7
    } else if (option == "g") {
        x_index = 4
    } else if (option == "h") {
        x_index = 6
    } else if (option == "p") {
        x_index = 5
    }
}

# This block processes each record after the first (header).
NR > 1 {
    if (!seen[$1]++) {  # If the country hasn't been seen before, store it.
        country[n] = $1  # Store country name.
        n += 1           # Increment the country index.
    }
    records[NR] = $0  # Store the entire record.
}

END {
    # Loop through each country for which data was collected.
    for (n = 1; n <= length(country); n++) {
        # Initialize variables for statistical calculations.
        total_x = 0;
        total_y = 0;
        sum_x_y = 0;
        sum_x_sq = 0;
        sum_y_sq = 0;
        count = 0;
        N = 0;

        # Process each record to calculate sums and counts needed for correlation.
        for (i = 1; i <= NR; i++) {
            if (records[i] == "") {
                continue  # Skip empty records.
            }

            split(records[i], fields, FS)  # Split the record into fields.

            if (fields[8] == "") {
                continue  # Skip records where the y-variable (cantril data) is empty.
            }

            if (fields[1] == country[n]) {  # Check if the record belongs to the current country.
                x = fields[x_index];  # Use dynamically determined index for x.
                y = fields[8];  # Always use column 8 for y.
                total_x += x;
                total_y += y;
                sum_x_y += x * y;
                sum_x_sq += x * x;
                sum_y_sq += y * y;
                N += 1  # Count valid pairs.
                if (x > 0 && y > 0) {
                    count += 1;  # Count pairs where both x and y are positive.
                }
            }
        }

        if (count < 3) {
            continue;  # Skip correlation calculation if less than 3 pairs.
        }

        # Calculate the correlation coefficient.
        r_1 = (N * sum_x_y) - (total_x * total_y);
        r_2 = sqrt(((N * sum_x_sq) - (total_x ^ 2)) * ((N * sum_y_sq) - (total_y ^ 2)));

        if (r_1 == 0 || r_2 == 0) {
            R = 0;  # Avoid division by zero.
        } else {
            R = r_1 / r_2;  # Compute correlation coefficient.
        }
        
        print country[n], R;  # Output country name and its correlation coefficient.
        country_sd[n] = R;  # Optionally store the correlation coefficient.
    }
}
