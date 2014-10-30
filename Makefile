VLOG	= ncverilog
SRC		= lzc.v \
		  lzc_t.v
SRC2	= lzc_bonus.v \
		  lzc_bonus_t.v
VLOGARG	= +access+r

TMPFILE	= *.log \
		  ncverilog.key \
		  nWaveLog \
		  INCA_libs

DBFILE	= *.fsdb *.vcd *.bak

RM		= -rm -rf

all :: sim
sim :
		$(VLOG) $(SRC) $(VLOGARG)
sim2 :
		$(VLOG) $(SRC2) $(VLOGARG)
clean :
		$(RM) $(TMPFILE)
veryclean :
		$(RM) $(TMPFILE) $(DBFILE)

