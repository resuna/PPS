#!/bin/sh

lines=60
cols=80
tabs=8
title="Standard Input"
date="`date`"
while
  case $1 in
    -h)
      shift
      title="$1"
      shift
      true;;
    -d)
      shift
      date="$1"
      shift
      true;;
    -l)
      shift
      lines=$1
      shift
      true;;
    -c)
      shift
      cols=$1
      shift
      true;;
    -t)
      shift
      tabs=$1
      shift
      true;;
    -*)
      echo "Usage: %s [-t tabs] [-l lines] [-c cols] [-h title] [-d date] [file]..." 1>&2
      exit 2;;
    *)
      false;;
  esac
do :
done

echo "%!"
echo "/LINES $lines def"
echo "/COLS $cols def"
echo "/DATE ($date) def"
echo "/TITLE ($title) def"

cat << \!
/inch { 72 mul } def

% Tune the page appearance here:
%GS% Denotes the "nice" settings for Ghostscript
%LN% For DEC LN03-R

% Fonts and line spacing...
/YSCALE 7.5 inch LINES 1 add div def
/XSCALE 4.5 inch 0.6 div COLS div def
/SCALE [XSCALE 0 0 YSCALE 0 0] def
/courier-normal /Courier findfont SCALE makefont def
/courier-slant /Courier-Oblique findfont SCALE makefont def
/courier-bold /Courier-Bold findfont SCALE makefont def
/courier courier-normal def
/ROMAN /NewCenturySchlbk-Bold findfont 12 scalefont def
/ITALIC /NewCenturySchlbk-BoldItalic findfont 12 scalefont def
/spacing YSCALE def

/indent 0.5 inch def

% Where does the title bar go?
/bar 10.25 inch def

/mbar 5.25 inch def

% Where does the text go?
/margin1 bar 0.125 inch sub def
/margin2 mbar 0.125 inch sub def
/top 7.5 inch spacing sub def
/bottom 0 def
/chwidth 4.5 inch COLS div def
/colno 0 def

% Where does the title go?
/titleplace bar 6 add def
/left 0.5 inch def
/right 8 inch def
/middle 4.25 inch def

% Generally don't want to mess with this:

/NORMAL { /courier courier-normal def } def
/BOLD { /courier courier-bold def } def
/SLANT { /courier courier-slant def } def

/BOF {
	/line -1 def
	/pno 0 def
} def

/title {
	newpath 0.5 inch bar moveto 8 inch bar lineto stroke
	NAMEFONT setfont
	0.5 inch titleplace moveto
	FILENAME show
	DATEFONT setfont
	right FILEDATE stringwidth pop sub titleplace moveto
	FILEDATE show
	ROMAN setfont
	pno 1 add dup /pno exch def (     ) cvs
	dup
	  stringwidth pop 2 div middle exch sub titleplace moveto
	show
	/line top def
	/colno 0 def
} def

/newpage {
	colno 0 eq {
		/colno 1 def
		/line top def
		pno 1 add dup /pno exch def (     ) cvs
		dup
		  stringwidth pop 2 div middle exch sub mbar 6 add moveto
		show
		newpath 0.5 inch mbar moveto 8 inch mbar lineto stroke
	} {
		showpage
		title
	} ifelse
} def
	
/NL {
	line spacing sub bottom lt {
		line -1 eq {
			title
		} {
			newpage
		} ifelse
	} {
		/line line spacing sub def
	} ifelse
	/col 0 def
} def
/FF {
	newpage
} def
/EOF {
	line -1 ne { showpage } if
	BOF
} def
/trans {
	indent colno 0 eq { margin1 } { margin2 } ifelse translate
	270 rotate
} def
/P {
	gsave trans
	  courier setfont
	  col line moveto
	  dup show
	  stringwidth pop col add /col exch def
	grestore
} def
/WRAP {
	gsave trans
	  newpath
	  4.625 inch line moveto
	  4.625 inch line spacing 2 div add lineto
	  4.625 inch spacing 4 div add line spacing 4 div add lineto
	  closepath fill
	grestore
} def
/T {
	chwidth mul /col exch def
} def
/OS {
	gsave trans
	  courier setfont
	  dup {
		col line moveto show
	  } forall
	  0 exch {
		stringwidth pop 2 copy lt {
			exch
		} if pop
	  } forall col add /col exch def
	grestore
} def
!
preps -l$lines -t$tabs ${1+"$@"}
