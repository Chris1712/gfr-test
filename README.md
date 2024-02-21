# Gunfire Reborn Test

## Wiki scraping

We need to obtain icons and data from the fandom wiki. I've tried to make this a repeatable process so gameplay updates can be captured:

Tools needed:
- wget
- grep
- jq
- [htmlq](https://github.com/mgdm/htmlq) - or something similar, for extracting html sections conveniently on the CLI

### 1. Grab data from the wiki
```
rm -r scraped-data && wget -p -k -P scraped-data https://gunfirereborn.fandom.com/wiki/Occult_Scrolls
mv scraped-data/gunfirereborn.fandom.com/wiki/Occult_Scrolls scraped-data
rm -r scraped-data/gunfirereborn.fandom.com
```


Now, in `scraped-data/gunfirereborn.fandom.com/wiki/Occult_Scrolls` we have the html for the Occult Scrolls page in the wiki

Each of the files created has a <tr> for each scroll. Each looks like this:

```
<tr>
<td>
    <div class="center">
        <div style="background: #161616;border:1px solid #C6260D; width:66px">
            <a href="https://gunfirereborn.fandom.com/wiki/Stubborn_Stance" title="Stubborn Stance">
                <img alt="Stubborn Stance" src="data:image/gif;base64,R0lGODlhAQABAIABAAAAAP///yH5BAEAAAEALAAAAAABAAEAQAICTAEAOw%3D%3D" decoding="async" loading="lazy" width="64" height="64" data-image-name="Stubborn Stance.png" data-image-key="Stubborn_Stance.png" data-relevant="0" data-src="https://static.wikia.nocookie.net/gunfire_reborn/images/8/89/Stubborn_Stance.png/revision/latest/scale-to-width-down/64?cb=20230601103054" class="lazyload" />
            </a>
        </div>
    <a href="https://gunfirereborn.fandom.com/wiki/Stubborn_Stance" title="Stubborn Stance">Stubborn Stance</a>
    </div>
</td>
<td>Unable to pick up shared Occult Scrolls from teammates or share Occult Scrolls with teammates.
</td></tr>
```

### 2. Process the data and obtain all the needed resources

Run `process-scraped-html.sh` to use the downloaded html and build a json array holding all of the useful scroll data.
It also downloads the scroll images.
