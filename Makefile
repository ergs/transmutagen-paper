LATEXMK = latexmk
GOOGLE_DRIVE = ~/Google\ Drive/

all: paper.pdf

%.pdf: %.tex
	$(LATEXMK) -halt-on-error -pdf -M -MP -MF $*.d $*

origen-speed.tex: origen-scopatz.pdf origen-aaron.pdf origen-meeseeks.pdf

origen-scopatz.pdf:
	python -m transmutagen.analysis --origen --origen-results $(GOOGLE_DRIVE)/ERGS\ Private/transmutagen\ data/scopatz_laptop_results_20170508.hdf5 --save-file origen-scopatz.pdf

origen-aaron.pdf:
	python -m transmutagen.analysis --origen --origen-results $(GOOGLE_DRIVE)/ERGS\ Private/transmutagen\ data/aaron_laptop_results_20170508.hdf5 --save-file origen-aaron.pdf

origen-meeseeks.pdf:
	python -m transmutagen.analysis --origen --origen-results $(GOOGLE_DRIVE)/ERGS\ Private/transmutagen\ data/meeseeks01_results_20170508.hdf5 --save-file origen-meeseeks.pdf

.PHONY: clean
clean:
	$(LATEXMK) -C
	(rm -rf *.ps *.log *.dvi *.aux *.*% *.lof *.lop *.lot *.toc *.idx *.ilg *.ind *.bbl *.blg *.cpt *-diff.tex *.out *.d)


-include *.d
