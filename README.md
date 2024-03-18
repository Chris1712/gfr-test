# Gunfire Reborn Test

Test your GFR knowledge!

This project contains setup for scraping data and then the gfr-app

## Building the app

The app is a vite-powered vue project created in Feb 2024 by `npm create vue@latest`

## Deploying

Host this in a public AWS S3 bucket, see the tf directory for setup (`aws configure && terraform plan && terraform apply`)

Note that the route 53 nameservers need to be set on namecheap.

To deploy a new version:
```
cd gfr-app
npm run build
aws s3 sync dist/ s3://gunfire.pro --acl public-read --delete
```

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

An example of the second <td> for an enhanced scroll: 
```
<td>
  +10% DMG Resistance and +30% DMG Dealt for 10s whenever you consume 100 ammo.
  <br><br>
  <a href="https://gunfirereborn.fandom.com/wiki/Reincarnation" title="Reincarnation">Enhanced</a>
  (<a href="https://gunfirereborn.fandom.com/wiki/Talents" title="Talents">
    <img alt="Soul Essence" class="lazyload" data-image-key="Soul_Essence.png" data-image-name="Soul Essence.png" data-relevant="0" data-src="https://static.wikia.nocookie.net/gunfire_reborn/images/b/bd/Soul_Essence.png/revision/latest/scale-to-width-down/24?cb=20200806132723" decoding="async" height="24" loading="lazy" src="data:image/gif;base64,R0lGODlhAQABAIABAAAAAP///yH5BAEAAAEALAAAAAABAAEAQAICTAEAOw%3D%3D" width="24">
  </a>
  <a href="https://gunfirereborn.fandom.com/wiki/Talents" title="Talents">60</a>
  <sup>
    <abbr title="Soul Essence is used to upgrade permanent Talents after each run.">?</abbr>
  </sup>): +10% DMG Resistance and +30% weapon and skill DMG for 3s whenever you consume 10 ammo. 
</td>
```

### 2. Process the data and obtain all the needed resources

Run `process-scraped-html.sh` to use the downloaded html and build a json array holding all of the useful scroll data.
It also downloads the scroll images.

### 3. Copy the data into the app

If we've got changed data we're interested in:

`mv processed-data/scrolls.json gfr-app/src/assets/`
`rm -r gfr-app/src/assets/scroll-images && cp -r processed-data/images/ gfr-app/src/assets/scroll-images`

Remember to commit everything too!


### TODO

- Some nice tests!
