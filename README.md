# PPS
Postscript Pretty Printer

_It's really pretty._

## Usage
p2ps [-t tabs] [-l lines] [-c cols] [-h title] [-d date] [file]...

pps [-t tabs] [-l lines] [-c cols] [-h title] [-[fFi] font] [-d date] [-L[L]] [-N[period]] [[-from USERNAME] -to USERNAME] [-M magic] [-ISO] [-nh] [file]...

## pps
Prints pages 1-up, portrait

Various options added for formatting a FAX cover sheet. Because I needed to.

### fonts

<dl>
<dt>-f font<dd>Normal text font
<dt>-F font<dd>Numeric text font
<dt>-i font<dd>Italic/Oblique font if it's not generated by adding "Italic" to the default font.
<dt>-lucida<dd>Lucida Sans Typewriter
<dt>-tex<dd>Computer Modern Typewriter
</dl>

Default is Courier

Note: Computer Modern requires the files /usr/local/lib/cmfonts/cmtex10.pfb and /usr/local/lib/cmfonts/cmsltt10.pfb - you have to locate these yourself.

## p2ps
Prints pages 2-up, landscape

