import segno

qrcode = segno.make('https://github.com/mchlsd/integrating_pga')
qrcode.save('tese.pdf', dark="black", light="white", scale=5)
