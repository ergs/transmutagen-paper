LATEXMK = latexmk
GOOGLE_DRIVE = $(HOME)/Google\ Drive/
TRANSMUTAGEN = $(HOME)/Documents/transmutagen

export PYTHONPATH := $(TRANSMUTAGEN):$(TRANSMUTAGEN)/py_solve

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

cram-matrices.tex: eigenvals_pwru50.pdf eigenvals_decay.pdf

eigenvals_pwru50.pdf:
eigenvals_decay.pdf:
	python -m transmutagen.analysis --eigenvals --save-file eigenvals.pdf --pwru50-data=$(TRANSMUTAGEN)/data/pwru50_400000000000000.0.npz

.PHONY: clean
clean:
	$(LATEXMK) -C
	(rm -rf *.ps *.log *.dvi *.aux *.*% *.lof *.lop *.lot *.toc *.idx *.ilg *.ind *.bbl *.blg *.cpt *-diff.tex *.out *.d)


-include *.d
