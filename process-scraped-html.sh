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

    # To set an image title we find everything between / and .png in the url
    img_title=$(echo $img_url_short | grep -o '/[^/]*$')
    img_title="${img_title:1}" # Trim the leading /
    img_title="$(echo $img_title | sed 's/%[0-9][0-9]//g')" # remove any percent encoded chars
    echo img_title: $img_title

    full_desc=$(htmlq -f "$file" "tbody > tr:nth-of-type($row) > td:nth-of-type(2)")
    echo full_desc: $full_desc

    # If there is a <br> in the full_desc:
    if [[ $full_desc == *"<br>"* ]]; then
      # Then we've got a scroll with an enhanced version and we need to do some extra stuff
      desc=$(echo $full_desc | grep -o '<td>.*<br>' | sed 's/<td>//g' | sed 's/<br>//g')
      desc_enhanced=$(echo $full_desc | grep -o '</sup>.*</td>' | sed 's/<\/sup>//g' | sed 's/<\/td>//g' | sed 's/\"//g' )
      desc_enhanced="${desc_enhanced:3}" # Trim the leading 3 chars
      desc_enhanced="${desc_enhanced::${#desc_enhanced}-1}" # Trim the last char
      desc_enhanced=\"${desc_enhanced}\" # Wrap in quotes, since it's raw json
    else
      # Otherwise we can just use the full_desc as the desc
      desc=$(htmlq -f "$file" --text "tbody > tr:nth-of-type($row) > td:nth-of-type(2)")
      desc_enhanced=null
    fi

    echo desc: $desc
    echo desc_enhanced: $desc_enhanced

    # Create a JSON object for the current row and append it to the output file
    jq --arg type "$type" \
       --arg name "$name" \
       --arg link "$link" \
       --arg img_title "$img_title" \
       --arg desc "$desc" \
       --argjson desc_enhanced "$desc_enhanced" \
      '. += [{"type": $type, "name": $name, "link": $link, "imgTitle": $img_title, "desc": $desc, "descEnhanced": $desc_enhanced}]' "$output" > "${output}.tmp" && mv "${output}.tmp" "$output"

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
