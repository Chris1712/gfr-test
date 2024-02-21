# Gunfire Reborn Test

## Wiki scraping

We need to obtain icons and data from the fandom wiki. I've tried to make this a repeatable process so gameplay updates can be captured:

Tools needed:
- wget
- grep
- jq
- [htmlq](https://github.com/mgdm/htmlq) - or something similar, for extracting html sections conveniently on the CLI

### 1. Grab data from the wiki
`rm -r scraped-data && wget -p -k -P scraped-data https://gunfirereborn.fandom.com/wiki/Occult_Scrolls`

Now, in `scraped-data/gunfirereborn.fandom.com/wiki/Occult_Scrolls` we have the html for the Occult Scrolls page in the wiki

Each entry looks like this:

### 2. Pull out the image urls from the page, and pop them into a list
`grep -o 'https://static.wikia.nocookie.net/gunfire_reborn/images[^ ]*png' 'scraped-data/gunfirereborn.fandom.com/wiki/Occult_Scrolls' | sort | uniq > scraped-data/image-urls.txt`

### 3. Grab the images from the list
`while read -r url; do wget -P scraped-data/images/ "$url"; done < scraped-data/image-urls.txt`

### 4. Make an HTML file for each scroll category:
The page structure holds a dig with id 'mw-content-text'. This holds another div (class 'mw-parser-output'), which inside it has our tables.
First table is normal scrolls. Second is rare, third is legendary, fourth is cursed, fifth is removed. Each row is a scroll, where the second entry is the description.

```
mkdir -p scraped-data/tables
cat scraped-data/gunfirereborn.fandom.com/wiki/Occult_Scrolls| htmlq '#mw-content-text > div > table:nth-of-type(1)' > scraped-data/tables/normal.html
cat scraped-data/gunfirereborn.fandom.com/wiki/Occult_Scrolls| htmlq '#mw-content-text > div > table:nth-of-type(2)' > scraped-data/tables/rare.html
cat scraped-data/gunfirereborn.fandom.com/wiki/Occult_Scrolls| htmlq '#mw-content-text > div > table:nth-of-type(3)' > scraped-data/tables/legendary.html
cat scraped-data/gunfirereborn.fandom.com/wiki/Occult_Scrolls| htmlq '#mw-content-text > div > table:nth-of-type(4)' > scraped-data/tables/cursed.html
cat scraped-data/gunfirereborn.fandom.com/wiki/Occult_Scrolls| htmlq '#mw-content-text > div > table:nth-of-type(5)' > scraped-data/tables/removed.html
```

### 5. Extract the data from these tables into a single file suitable for consumption by our frontend

Each of the files created has a <tr> for each scroll. Each looks like this:

```
<tr>
<td><div class="center"><div style="background: #161616;border:1px solid #C6260D; width:66px"><a href="https://gunfirereborn.fandom.com/wiki/Stubborn_Stance" title="Stubborn Stance"><img alt="Stubborn Stance" src="data:image/gif;base64,R0lGODlhAQABAIABAAAAAP///yH5BAEAAAEALAAAAAABAAEAQAICTAEAOw%3D%3D" decoding="async" loading="lazy" width="64" height="64" data-image-name="Stubborn Stance.png" data-image-key="Stubborn_Stance.png" data-relevant="0" data-src="https://static.wikia.nocookie.net/gunfire_reborn/images/8/89/Stubborn_Stance.png/revision/latest/scale-to-width-down/64?cb=20230601103054" class="lazyload" /></a></div><a href="https://gunfirereborn.fandom.com/wiki/Stubborn_Stance" title="Stubborn Stance">Stubborn Stance</a></div></td>
<td>Unable to pick up shared Occult Scrolls from teammates or share Occult Scrolls with teammates.
</td></tr>
```

There's two `<td>` elements, the first holding a link to the specific page, an image url, and a title.
The second holds a string of text; where it's broken there's an enhanced version.

So, we need to loop through each file, and then loop through each row, find the attributes we want, and save the output into a json file.
`process-scraped.html.sh` does this.





# TODO

- Merge above steps into the bash script
- Download images from json
