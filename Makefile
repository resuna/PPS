BINDIR=/usr/local/bin
SHELL=/bin/sh

all: preps

install: $(BINDIR)/p2ps $(BINDIR)/pps $(BINDIR)/preps

pps.shar: Makefile p2ps.sh pps.sh preps.c pps.new.sh
	shar > pps.shar Makefile p2ps.sh pps.sh preps.c pps.new.sh

$(BINDIR)/p2ps: p2ps.sh
	cp p2ps.sh $(BINDIR)/p2ps

$(BINDIR)/pps: pps.sh
	cp pps.sh $(BINDIR)/pps

$(BINDIR)/preps: preps
	cp preps $(BINDIR)

psprint:
	pps -N Makefile p2ps.sh pps.sh preps.c | lpr -Pps
