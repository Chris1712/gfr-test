#!/bin/bash

# Define the output file
output="scraped-data/scrolls.json"
# Start with an empty JSON array
echo "[]" > "$output"

# Initialize total scrolls counter
total_scrolls=0

# Iterate over html files in the directory
for file in scraped-data/tables/*.html; do
  # Extract the filename without path and extension for use as a category
  type=$(basename -- "$file" .html)

  rows=$(grep -c '<tr>' "$file")
  count=$((rows - 1)) # First row is a header, so we've one less
  echo Found $count scrolls of type $type in $file

  for (( i = 1; i <= $count; i++ ))
  do
    # Loop through, note that this is a 1-indexed list (i starts at 1)
    echo Row $i
    # We have to add 1 to our row number; the first row is a header
    row=$((i + 1))
    content=$(htmlq -f "$file" "tbody > tr:nth-of-type($row)")
#     echo $content

    link=$(htmlq -f "$file" -a href -- "tbody > tr:nth-of-type($row) > td:nth-of-type(1) > div > div > a")
    echo link: $link
    img_url_full=$(htmlq -f "$file" -a data-src -- "tbody > tr:nth-of-type($row) > td:nth-of-type(1) > div > div > a > img")
    echo img_url_full: $img_url_full
    desc=$(htmlq -f "$file" --text "tbody > tr:nth-of-type($row) > td:nth-of-type(2)")
    echo desc: $desc


    # Create a JSON object for the current row and append it to the output file
    jq --arg type "$type" --arg link "$link" --arg img_url_full "$img_url_full" --arg desc "$desc" \
      '. += [{"type": $type, "link": $link, "img_url_full": $img_url_full, "desc": $desc}]' "$output" > "${output}.tmp" && mv "${output}.tmp" "$output"

  done


done
