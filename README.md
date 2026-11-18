# InfoCat
Cat themed Garmin watch face

## Resources

### Drawing Tool
[Grahpite](https://graphite.art/) - an open sourced, browser based, vector drawing software.

### Font
[M PLUS U](https://fonts.google.com/specimen/M+PLUS+U?preview.text=12:30%0AIl1%7C%0ANOV%20TUE%2017%20MON%20THU%20WED%20FRI&preview.layout=grid&categoryFilters=Appearance:%2FMonospace%2FMonospace&specimen.preview.text=12:30%0AIl1|%0ANOV+TUE+17+MON+THU+WED+FRI) designed by [Coji Morishita](https://fonts.google.com/?query=Coji+Morishita&preview.layout=grid); licensed under the [Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL).

### Font File Converter TTF to FNT
[SnowB Bitmap Font](https://snowb.org/)
To be compatible with Garmin, you must convert the png to use an RGB mask:
```bash
python3 -c 'from PIL import Image; from pathlib import Path; p=Path("resources/fonts/Font.png"); im=Image.open(p).convert("RGBA"); mask=im.getchannel("A"); opaque=Image.new("L", im.size, 255); Image.merge("RGBA", (mask, mask, mask, opaque)).save(p)'
```
