#!/bin/sh

lines=66
cols=80
tabs=8
title="Standard Input"
titlefont="Times-Bold"
numberfont="Times-Roman"
textfont=Courier
faxfrom="$NAME"
underline=false
mail=false
bold=-Bold
slant=-Oblique
titlesize=12
date="`date`"
number=false
iso=false
period=10
magic=
while
  case $1 in
    -ISO)
      shift
      iso=true
      true;;
    -M)
      shift
      magic="-m$1"
      shift
      true;;
    -h)
      shift
      title="$1"
      shift
      true;;
    -nh)
      shift
      title=NONE
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
    -lucida)
      shift
      textfont=LucidaSans-Typewriter
      underline=true
      bold=Bold
      true;;
    -underline)
      shift
      underline=true
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
    -f)
      shift
      titlefont=$1
      shift
      true;;
    -F)
      shift
      numberfont=$1
      shift
      true;;
    -L)
      shift
      lines=99
      cols=120
      true;;
    -LL)
      shift
      lines=132
      cols=160
      true;;
    -N)
      shift
      number=true
      true;;
    -N*)
      period=`echo $1 | sed 's/-N//'`
      shift
      number=true
      if [ ! "$period" ]
      then period=$1; shift
      fi
      true;;
    -from)
      shift
      faxfrom="$1"
      shift
      true;;
    -to)
      shift
      faxto="$1"
      shift
      true;;
    -mail)
      shift
      mail=true
      true;;
    -*)
      echo "Usage: pps [-t tabs] [-l lines] [-c cols] [-h title]" 1>&2
      echo "           [-[fF] font] [-d date] [-L[L]] [-N[period]]" 1>&2
      echo "           [[-from USERNAME] -to USERNAME]" 1>&2
      echo "           [-M magic] [-ISO] [-nh] [file]..." 1>&2
      exit 2;;
    *)
      false;;
  esac
do :
done

echo "%!"

if [ "$iso" = "true" ]
then
cat << \!
%Define ISO Character Set

/reencsmalldict 12 dict def
/ReEncodeSmall
{ reencsmalldict begin
  /newcodesandnames exch def
  /newfontname exch def
  /basefontname exch def

  /basefontdict basefontname findfont def
  /newfont basefontdict maxlength dict def

  basefontdict 
  { exch dup /FID ne
    { dup /Encoding eq
      { exch dup length array copy newfont 3 1 roll put }
      { exch newfont 3 1 roll put }
      ifelse
    }
    { pop pop }
  ifelse
  } forall

  newfont /FontName newfontname put
  newcodesandnames aload pop

  newcodesandnames length 2 idiv
  { newfont /Encoding get 3 1 roll put } repeat

  newfontname newfont definefont pop
  end
} def

/ISOVec[
16#27 /quotesingle 	16#60 /grave		16#7C /bar
16#91 /quoteleft 	16#92 /quoteright 	16#93 /quotedblleft 
16#94 /quotedblright 	16#95 /bullet 		16#96 /endash 
16#97 /emdash 		16#99 /trademark 	16#9A /scaron 
16#9B /guilsinglright 	16#9C /oe 		16#9F /Ydieresis 
16#A0 /space 		16#A4 /currency 	16#A6 /brokenbar 
16#A7 /section		16#A8 /dieresis 	16#A9 /copyright 
16#AA /ordfeminine 	16#AB /guillemotleft	16#AC /logicalnot 
16#AD /hyphen 		16#AE /registered 	16#AF /macron 
16#B0 /degree		16#B1 /plusminus 	16#B2 /twosuperior 
16#B3 /threesuperior 	16#B4 /acute 		16#B5 /mu 
16#B6 /paragraph 	16#B7 /periodcentered 	16#B8 /cedilla 
16#B9 /onesuperior	16#BA /ordmasculine 	16#BB /guillemotright 
16#BC /onequarter 	16#BD /onehalf		16#BE /threequarters 
16#BF /questiondown 	16#C0 /Agrave 		16#C1 /Aacute 
16#C2 /Acircumflex 	16#C3 /Atilde 		16#C4 /Adieresis 
16#C5 /Aring 		16#C6 /AE 		16#C7 /Ccedilla 
16#C8 /Egrave 		16#C9 /Eacute 		16#CA /Ecircumflex 
16#CB /Edieresis	16#CC /Igrave 		16#CD /Iacute 
16#CE /Icircumflex 	16#CF /Idieresis 	16#D0 /Eth 	
16#D1 /Ntilde 		16#D2 /Ograve 		16#D3 /Oacute 	
16#D4 /Ocircumflex 	16#D5 /Otilde		16#D6 /Odieresis 
16#D7 /multiply 	16#D8 /Oslash 		16#D9 /Ugrave 
16#DA /Uacute		16#DB /Ucircumflex 	16#DC /Udieresis 
16#DD /Yacute 		16#DE /Thorn 		16#DF /germandbls
16#E0 /agrave 		16#E1 /aacute 		16#E2 /acircumflex 
16#E3 /atilde 		16#E4 /adieresis	16#E5 /aring 
16#E6 /ae 		16#E7 /ccedilla 	16#E8 /egrave 
16#E9 /eacute 		16#EA /ecircumflex 	16#EB /edieresis 
16#EC /igrave 		16#ED /iacute 		16#EE /icircumflex
16#EF /idieresis 	16#F0 /eth 		16#F1 /ntilde 
16#F2 /ograve 		16#F3 /oacute 		16#F4 /ocircumflex 
16#F5 /otilde 		16#F6 /odieresis 	16#F7 /divide 
16#F8 /oslash		16#F9 /ugrave 		16#FA /uacute 
16#FB /ucircumflex 	16#FC /udieresis 	16#FD /yacute
16#FE /thorn 		16#FF /ydieresis 
] def 

!
  if [ $underline = false ]
  then
    echo "/$textfont$slant /ISO-$textfont$slant ISOVec ReEncodeSmall"
  fi
  echo "/$textfont /ISO-$textfont ISOVec ReEncodeSmall"
  echo "/$textfont$bold /ISO-$textfont$bold ISOVec ReEncodeSmall"
  echo "/$titlefont /ISO-$titlefont ISOVec ReEncodeSmall"
  echo "/${titlefont}Italic /ISO-${titlefont}Italic ISOVec ReEncodeSmall"
  if [ "$number" = "true" ]
  then echo "/$numberfont /ISO-$numberfont ISOVec ReEncodeSmall"
  fi
  titlefont=ISO-$titlefont
  numberfont=ISO-$numberfont
  courier=ISO-$textfont
else
  courier=$textfont
fi

if [ "$faxto" ]
then
  echo "/FAX true def   /FAXTO (  To: $faxto) def   /FAXFROM (From: $faxfrom) def"
else
  echo "/FAX false def"
fi
echo "/LINES $lines def"
echo "/COLS $cols def"
echo "/DATE ($date) def"
if [ NONE = "$title" ]
then 
  echo "/TITLE () def"
  echo "/SIMPLE true def"
else
  echo "/TITLE ($title) def"
  echo "/SIMPLE false def"
fi
echo "/ROMANFONT /${titlefont} def"
echo "/ITALICFONT /${titlefont}Italic def"
echo "/FONTSIZE $titlesize def"
if [ "$number" = "true" ]
then echo "/NUMBERFONT /$numberfont def"
fi
echo "/NORMALFONT /$courier def"
echo "/BOLDFONT /$courier$bold def"
if [ $underline = false ]
then
  echo "/SLANTFONT /$courier$slant def"
  echo "/has-slant true def"
else
  echo "/has-slant false def"
fi

if [ "$number" = "false" ]
then echo "/numberline {} def /reset_numbers {} def"
else
echo "/period $period def"
cat << \!

/NUMBER NUMBERFONT findfont FONTSIZE scalefont def

/reset_numbers {
  /line_number 0 def
} def

/numberline {
  /line_number line_number 1 add def
  line_number period mod 0 eq {
    gsave
      indent spacing 2 mul sub line translate
      spacing 2 mul 3 div FONTSIZE div
        dup scale
      NUMBER setfont
      line_number (          ) cvs
	dup stringwidth pop neg 0 moveto
	show
    grestore
  } if
} def
!
fi

cat << \!
/inch { 72 mul } def

% Tune the page appearance here:
%GS% Denotes the "nice" settings for Ghostscript
%LN% For DEC LN03-R

/xsize 6.5 inch def
%LN%/ysize 9.5 inch def
%GS%/ysize 10 inch def
/ysize SIMPLE {10} {9.5} ifelse inch def

% Fonts and line spacing...
/xscale xsize 0.6 div COLS div def
/yscale ysize LINES div def
/fontscale [xscale 0 0 yscale 0 0] def
/fixed-normal NORMALFONT findfont fontscale makefont def
has-slant {/fixed-slant SLANTFONT findfont fontscale makefont def} if
/fixed-bold BOLDFONT findfont fontscale makefont def
/FIXED fixed-normal def
/ROMAN ROMANFONT findfont FONTSIZE scalefont def % ROMAN called from preps
/ITALIC ITALICFONT findfont FONTSIZE scalefont def % ITALIC called from preps

% Where does the text go?
/bottom 0.5 inch def
/top bottom ysize add def
/indent 1.0 inch def
/margin indent xsize add def
/chwidth margin indent sub COLS div def
/spacing yscale def

% Where does the title bar go?
/bar top 0.25 inch add def

% Where does the title go?
/titleplace bar 10 add def
/left 0.5 inch def
/right 8 inch def
/middle 4.25 inch def

% Size of the little arrow at the bottom of the page
/ptroff 0.0625 inch def
/ptrwidth 0.0625 inch def
/ptrheight ptrwidth 2 mul def

% Generally don't want to mess with this:

/NORMAL {
  /FIXED fixed-normal def
  /underline false def
} def
/BOLD {
  /FIXED fixed-bold def
  /underline false def
} def
/SLANT {
  has-slant {
    /FIXED fixed-slant def
  } {
    /FIXED fixed-normal def
    /underline true def
  }
} def

/BOF {
	/line -1 def
	/pno 0 def
	/wrapped false def
	reset_numbers
} def

/tag {
	gsave
	  right ptroff add ptrwidth add
	    exch translate
	  90 rotate
	  0.5 0.5 scale
	  0 0 moveto
	  NAMEFONT setfont
	  FILENAME show
	grestore
} def

/title {
	SIMPLE {
	  pno 1 add /pno def
	} {
	  newpath left bar moveto right bar lineto stroke
	  FAX {
	    DATEFONT setfont
	    right FILEDATE stringwidth pop sub titleplace FONTSIZE add moveto
	    FILEDATE show

	    NAMEFONT setfont
	    right FILENAME stringwidth pop sub titleplace moveto
	    FILENAME show

	    fixed-bold setfont

	    left titleplace FONTSIZE add moveto
	    FAXFROM show

	    left titleplace moveto
	    FAXTO show

	    ROMAN setfont

	    pno 1 add dup /pno exch def (     ) cvs
	    dup stringwidth pop 2 div middle exch sub
		titleplace FONTSIZE 2 div add moveto show
	  } {
	    DATEFONT setfont
	    left titleplace moveto
	    FILEDATE show
	    NAMEFONT setfont
	    right FILENAME stringwidth pop sub titleplace moveto
	    FILENAME show
	    ROMAN setfont
	    pno 1 add dup /pno exch def (     ) cvs
	    dup stringwidth pop 2 div middle exch sub titleplace moveto show
	  } ifelse
	} ifelse
	/line top def
} def
/EOP {
	SIMPLE not {
	  newpath
	  right ptroff add % column
	    dup bottom moveto
	    dup ptrwidth 2 div add bottom ptrheight sub lineto
	        ptrwidth add bottom lineto
	  closepath fill
	  bottom ptroff add tag
	} if
	showpage
} def
/NL {
	line spacing sub bottom lt {
		line -1 ne { EOP } if
		title
	} {
		/line line spacing sub def
	} ifelse
	/col indent def
	wrapped { unwrap } { numberline } ifelse
} def
/FF {
	EOP title
} def
/EOF {
	SIMPLE not {
	  /line line spacing sub def
	  line bottom ge {
		newpath left line moveto right line lineto stroke
	  } if
	  line tag
	} if
	showpage
	BOF
} def
/WRAP {
	newpath
	margin ptroff add
	  dup line moveto
	  dup line spacing 2 div add lineto
	      spacing 4 div add line spacing 4 div add lineto
	closepath fill
	/wrapped true def
} def
/unwrap {
	newpath
	indent ptroff sub
	  dup line moveto
	  dup line spacing 2 div add lineto
	      spacing 4 div sub line spacing 4 div add lineto
	closepath fill
	/wrapped false def
} def
/P {
	underline {
	  col line
	} if
	FIXED setfont
	col line moveto
	dup show
	stringwidth pop col add /col exch def
	underline {
	  newpath moveto col line lineto stroke
	} if
} def
/T {
	chwidth mul indent add /col exch def
} def
/OS {
	FIXED setfont
	dup {
		col line moveto show
	} forall
	0 exch {
		stringwidth pop 2 copy lt {
			exch
		} if pop
	} forall col add /col exch def
} def
!
if [ true = $mail ]
then
cat << \!

/title {
	newpath left bar moveto right bar lineto stroke
	ROMAN setfont
	right DATE stringwidth pop sub titleplace FONTSIZE add moveto
	DATE show

	ROMAN setfont
	right SUBJECT stringwidth pop sub titleplace moveto
	SUBJECT show

	left titleplace FONTSIZE add moveto
	ROMAN setfont (From: ) show
	fixed-bold setfont FROM show

	left
	  titleplace (From: ) stringwidth pop (To: ) stringwidth pop sub add
	  moveto
	ROMAN setfont (To: ) show
	fixed-bold setfont TO show

	ROMAN setfont

	pno 1 add dup /pno exch def (     ) cvs
	dup stringwidth pop 2 div middle exch sub
		titleplace FONTSIZE 2 div add moveto show
	/line top def
} def
/BODY {
	newpath left line moveto right line lineto stroke NL
} def
/HEADER {
} def
!
  preps $magic -e -w$cols -t$tabs ${1+"$@"}
else
  preps $magic -w$cols -t$tabs ${1+"$@"}
fi
