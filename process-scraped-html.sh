#!/bin/bash

# Script for translating the wiki page for scrolls into a useful json object.
# It also downloads the images, and is smart enough to not-redownload if we've already got it
# Input is scraped-data/Occult_Scrolls
# Output is processed-data/


# Extract the HTML tables from the page, putting each one into a file.
rm -f processed-data/tables/*
cat scraped-data/Occult_Scrolls | htmlq '#mw-content-text > div > table:nth-of-type(1)' > processed-data/tables/normal.html
cat scraped-data/Occult_Scrolls | htmlq '#mw-content-text > div > table:nth-of-type(2)' > processed-data/tables/rare.html
cat scraped-data/Occult_Scrolls | htmlq '#mw-content-text > div > table:nth-of-type(3)' > processed-data/tables/legendary.html
cat scraped-data/Occult_Scrolls | htmlq '#mw-content-text > div > table:nth-of-type(4)' > processed-data/tables/cursed.html
cat scraped-data/Occult_Scrolls | htmlq '#mw-content-text > div > table:nth-of-type(5)' > processed-data/tables/removed.html


# Define the output file
output="processed-data/scrolls.json"
echo "[]" > "$output"

# Iterate over html files in the directory
for file in processed-data/tables/*.html; do
  # Extract the filename without path and extension for use as a category
  type=$(basename -- "$file" .html)

  rows=$(grep -c '<tr>' "$file")
  count=$((rows - 1)) # First row is a header, so we've one less
  echo Found $count scrolls of type $type in $file

  # Iterate through the rows in this file's table:
  # (Note that we are 1-indexed since css nth-of-type uses 1-indexing
  for (( i = 1; i <= $count; i++ ))
  do
    echo Row $i
    # We have to add 1 to our row number; the first row is a header
    row=$((i + 1))
    content=$(htmlq -f "$file" "tbody > tr:nth-of-type($row)")

    # Extract the data for storage
    name=$(htmlq -f "$file" --text "tbody > tr:nth-of-type($row) > td:nth-of-type(1) > div > a")
    echo name: $name

    link=$(htmlq -f "$file" -a href -- "tbody > tr:nth-of-type($row) > td:nth-of-type(1) > div > div > a")
    echo link: $link

    img_url_full=$(htmlq -f "$file" -a data-src -- "tbody > tr:nth-of-type($row) > td:nth-of-type(1) > div > div > a > img")
    echo img_url_full: $img_url_full

    # The img link has some clever scaling stuff that we don't want
    img_url_short=$(echo $img_url_full | grep -o 'http.*\.png')
    echo img_url_short: $img_url_short

    img_title=$(echo $img_url_short | grep -o '/[^/]*$')
    img_title="${img_title:1}"
    echo img_title: $img_title

    desc=$(htmlq -f "$file" --text "tbody > tr:nth-of-type($row) > td:nth-of-type(2)")
    echo desc: $desc


    # Create a JSON object for the current row and append it to the output file
    jq --arg type "$type" \
       --arg name "$name" \
       --arg link "$link" \
       --arg img_url_full "$img_url_full" \
       --arg img_url_short "$img_url_short" \
       --arg img_title "$img_title" \
       --arg desc "$desc" \
      '. += [{"type": $type, "name": $name, "link": $link, "img_url_full": $img_url_full, "img_url_short": $img_url_short, "img_title": $img_title, "desc": $desc}]' "$output" > "${output}.tmp" && mv "${output}.tmp" "$output"

    # Ensure that the image has been downloaded
    img_path=processed-data/images/$img_title
    echo img_path: $img_path
    if [ -f $img_path ]; then
      echo "Image already exists"
    else
      echo "Downloading"
      wget -O $img_path $img_url_short

    fi

  done
done

echo Done!
echo Image file count:
echo $(ls -1q processed-data/images | wc -l)
echo Array size:
echo $(jq length $output)
