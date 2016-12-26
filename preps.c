/* Preprocessor for text to pretty-print it in Postscript. */
#include <ctype.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>

#define MAXOVERSTRIKE 8
#define MAXWIDTH 512
#define MAXBUFFER (MAXOVERSTRIKE * MAXWIDTH)

int width = 80;
int tabstops = 8;
int pagelen = -1;
int filter = 0;
int count = 0;
int lines = 0;
char *magic = NULL;
int magiclen = 0;

char *prog;
char option;
int fullpage;

char *strrchr();

usage(s)
char *s;
{
	fprintf(stderr, "%s:", prog);
	if(option) fprintf(stderr, " -%c:", option);
	fprintf(stderr, " %s\n", s);
	fprintf(stderr, "Usage: %s [-t<tabwidth>] [-w<pagewidth>] [-m<magic>] [-f] [-c] [file]....\n", prog);
}

main(ac, av)
int ac;
char **av;
{
	FILE *fp;
	int gotfile;
	static char buffer[MAXBUFFER];
	char *t, *ctime();
	struct stat sb;
	int val;

	if(prog = strrchr(*av, '/'))
		prog++;
	else
		prog = *av;

	gotfile = 0;
	fullpage = 0;
	while(*++av) {
		option = 0;
		if(**av == '-') {
			while(*++*av) {
				switch(option = **av) {
					case 'c':
						count = !count;
						break;
					case 'f':
						filter = !filter;
						break;
					case 'm':
						++*av;
						if(!**av) {
							usage("Missing argument.\n");
							exit(2);
						}
						magic = *av;
						magiclen = strlen(magic);
						*av += magiclen-1;
						break;
					case 'w':
					case 't':
						++*av;
					case 'p':
						if(!**av) {
							usage("Missing argument.\n");
							exit(2);
						}
						if(!isdigit(**av)) {
							usage("Option requires numeric argument.\n");
							exit(2);
						}
						val = 0;
						while(isdigit(**av)) {
							val = val * 10 + **av - '0';
							++*av;
						}
						--*av;
						switch(option) {
							case 'w': width = val; break;
							case 't': tabstops = val; break;
							case 'p': pagelen = val; break;
						}
						break;
					default:
						usage("Unknown option");
						exit(2);
				}
			}
		} else if(!(fp = fopen(*av, "r"))) {
			perror(*av);
			exit(1);
		} else {
			gotfile = 1;
			if(fstat(fileno(fp), &sb) == 0) {
				t = ctime(&sb.st_mtime);
				t[strlen(t)-1] = 0;
				printf("/FILEDATE (%s) def\n", t);
				printf("/DATEFONT ROMAN def\n");
			} else {
				printf("/FILEDATE DATE def\n");
				printf("/DATEFONT ITALIC def\n");
			}
			printf("/FILENAME (%s) def\n", *av);
			printf("/NAMEFONT ROMAN def\n");
			if(!filter) printf("BOF\n");
			initfile();
			while(fgets(buffer, sizeof(buffer), fp)) {
				puttext(buffer);
			}
			if(!filter) printf("EOF\n");
			fclose(fp);
		}
	}
	if(!gotfile) {
		printf("/FILEDATE DATE def\n");
		printf("/DATEFONT ITALIC def\n");
		printf("/FILENAME TITLE def\n", *av);
		printf("/NAMEFONT ITALIC def\n");
		if(!filter) printf("BOF\n");
		initfile();
		while(fgets(buffer, sizeof(buffer), stdin)) {
			puttext(buffer);
		}
		if(!filter) printf("EOF\n");
	}
	if(count)
		fprintf(stderr, "%d lines\n", lines);
	exit(0);
}

char workbuf[MAXOVERSTRIKE][MAXWIDTH];
int depth[MAXWIDTH];
int style[MAXWIDTH];
#define NORMAL 0
#define BOLD 1
#define ITALIC 2
#define UNKNOWN 3
char   *stylename[4] = {
	"NORMAL ", "BOLD ", "SLANT ", "(Can't Happen!) print "
};
int oldstyle;
int col;
int line;
int page;

initfile()
{
	oldstyle = UNKNOWN;
	line = 0;
	page = 0;
}

initbuf()
{
	int i;

	for(col = 0; col < width; col++) {
		depth[col] = 0;
		style[col] = UNKNOWN;
		for(i = 0; i < MAXOVERSTRIKE; i++) {
			workbuf[i][col] = 0;
		}
	}

	col = 0;
}

begintext()
{
	printf("(");
}

endtext()
{
	printf(") P ");
}

printab(col)
int col;
{
	printf("%d T ", col);
}

printos(col)
int col;
{
	int i;
	printf("[ ");
	for(i = 0; i < depth[col]; i++) {
		printf("(");
		printchar(col, i);
		printf(") ");
	}
	printf("] OS ");
}

printchar(col, d)
int col, d;
{
	char c = workbuf[d][col];

	if( (c & 0x80) == 0 ) {
		if(strchr("()\\", c))
			putchar('\\');
		putchar(c);
	}
	else printf("\\%03o", c & 0xFF);
}

patch_style()
{
	int col, i;

	for(col = 0; col < width; col++) {
		if(workbuf[0][col] == ' ' || depth[col] == 0) {
			if(col == 0) {
				if(oldstyle == UNKNOWN)
					style[col] = NORMAL;
				else
					style[col] = oldstyle;
			} else {
				if(style[col-1] == UNKNOWN)
					style[col] = NORMAL;
				else
					style[col] = style[col-1];
			}
		} else if(workbuf[0][col] == '_' && style[col] == ITALIC) {
			if(col == 0 || style[col-1] != ITALIC)
				style[col] = BOLD;
		} else if(depth[col] > 1) {
			for(i = 1; i < depth[col]; i++)
				if(workbuf[i][col] != workbuf[i-1][col])
					break;
			if(i == depth[col]) {
				depth[col] = 1;
				style[col] = BOLD;
			}
		}
	}
}

endline()
{
	int intab = 0;
	int intext = 0;
	int col;
	int newstyle;

	if(pagelen > 0 && line >= pagelen) {
		line = 0;
		printf("EOP\n%%Page %d %d\n", ++page, ++fullpage);
	}
	patch_style();
	printf("NL ");
	lines++;
	line++;
	for(col = 0; col < width; col++) {
		if(style[col] == UNKNOWN)
			newstyle = NORMAL;
		else
			newstyle = style[col];
		switch(depth[col]) {
			case 0:
				if(intext) {
					endtext();
					intext = 0;
				}
				intab = 1;
				break;
			case 1: 
				if(intab) {
					printab(col);
					intab = 0;
				}
				if(oldstyle != newstyle) {
					if(intext) endtext();
					printf("%s", stylename[newstyle]);
					begintext();
					intext = 1;
					oldstyle = newstyle;
				}
				else if(!intext) {
					begintext();
					intext = 1;
				}
				printchar(col, 0);
				break;
			default:
				if(intab) {
					printab(col);
					intab = 0;
				}
				if(intext) {
					endtext();
					intext = 0;
				}
				if(oldstyle != newstyle) {
					printf("%s", stylename[newstyle]);
					oldstyle = newstyle;
				}
				printos(col);
				break;
		}
	}
	if(intext)
		endtext();
}

pchar(c)
char c;
{
	int i;

	if(col>=width) {
		endline();
		printf("WRAP ");
		lines++;
		initbuf();
	}

	switch(c) {
	    case '_':
		if(depth[col] == 0) {
			depth[col] = 1;
			workbuf[0][col] = '_';
		} else if(depth[col] == 1) {
			if(style[col] == NORMAL || style[col] == UNKNOWN)
				style[col] = ITALIC;
		}
		break;
	    case ' ':
		if(depth[col] == 0) {
			depth[col] = 1;
			workbuf[0][col] = ' ';
		}
		break;
	    default:
		switch(workbuf[0][col]) {
		    case '_':
			style[col] = ITALIC;
		    case ' ':
			workbuf[0][col] = c;
			break;
		    default:
			if(depth[col] < MAXOVERSTRIKE)
				workbuf[depth[col]++][col] = c;
			if(style[col] == UNKNOWN)
				style[col] = NORMAL;
			break;
		}
		break;
	}

	col++;
}

ptab()
{
	col += tabstops - col%tabstops;
}

pcr()
{
	col = 0;
}

pbs()
{
	if(col>0) col--;
}

pff()
{
	endline();
	printf("FF\n");
}

puttext(s)
char *s;
{
	if(magic && (strncmp(s, magic, magiclen) == 0)) {
		s += magiclen;
		if(oldstyle != NORMAL)
			printf("%s", stylename[NORMAL]);
		oldstyle = UNKNOWN;
		printf("%s", s);
		return;
	}
		
	initbuf();

	while(*s) {
		switch(*s) {
			case '\b': pbs(); break;
			case '\t': ptab(); break;
			case '\r': pcr(); break;
			case '\f': pff(); break;
			default:
				if(isprint(*s&0x7F))
					pchar(*s);
				break;
		}
		s++;
	}
	endline();
	putchar('\n');
}
