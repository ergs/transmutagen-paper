LATEXMK = latexmk
GOOGLE_DRIVE ?= $(HOME)/Google\ Drive/
TRANSMUTAGEN_DATA ?= $(GOOGLE_DRIVE)/ERGS\ Private/transmutagen\ data/
TRANSMUTAGEN ?= $(HOME)/Documents/transmutagen
PYNE ?= $(HOME)/Documents/pyne

export PYTHONPATH := $(TRANSMUTAGEN):$(TRANSMUTAGEN)/py_solve:$(PYNE)/build

all: paper.pdf

paper.pdf: origen-scopatz.pgf origen-aaron.pgf eigenvals_pwru50.pdf eigenvals_decay.pdf pusa-table-14.tex pusa-table-16.tex pusa-differences.pgf convergence-14-1000.pgf cram-plot.pgf nofission-pwru50-1-day.pgf nofission-pwru50-1-year.pgf nofission-pwru50-1000-years.pgf nofission-pwru50-1-million-years.pgf

%.pdf: %.tex
	$(LATEXMK) -lualatex -interaction=nonstopmode -use-make -f $*

origen-scopatz.pgf:
	python -m transmutagen.analysis --origen --no-title --origen-results $(TRANSMUTAGEN_DATA)/scopatz_laptop_results_20170508.hdf5 --file origen-scopatz.pgf

origen-aaron.pgf:
	python -m transmutagen.analysis --origen --no-title --origen-results $(TRANSMUTAGEN_DATA)/aaron_laptop_results_20170508.hdf5 --file origen-aaron.pgf

origen-meeseeks.pgf:
	python -m transmutagen.analysis --origen --no-title --origen-results $(TRANSMUTAGEN_DATA)/meeseeks01_results_20170508.hdf5 --file origen-meeseeks.pgf

eigenvals_pwru50.pdf eigenvals_decay.pdf:
	python -m transmutagen.analysis --eigenvals --no-title --file eigenvals.pdf --pwru50-data=$(TRANSMUTAGEN)/data/pwru50_400000000000000.0.npz

pusa-table-14.tex pusa-table-16.tex pusa-differences.pgf:
	python -m transmutagen.analysis --pusa-coeffs --file pusa-differences.pgf --latex pusa-table.tex

convergence-14-1000.pgf: generate_convergence_plot.py
	python generate_convergence_plot.py

cram-plot.pgf: cram_plot.py
	python cram_plot.py

nofission-pwru50-1-day.pgf nofission-pwru50-1-year.pgf nofission-pwru50-1000-years.pgf nofission-pwru50-1-million-years.pgf:
	python -m transmutagen.analysis --nofission  --file nofission.pgf

.PHONY: clean
clean:
	$(LATEXMK) -C
	-rm -rf *.ps *.log *.dvi *.aux *.*% *.lof *.lop *.lot *.toc *.idx *.ilg *.ind *.bbl *.blg *.cpt *-diff.tex *.out *.d
	-rm -rf origen-*.pdf eigenvals_*.pdf convergence-14-1000.pgf pusa-differences.pgf origen-scopatz.pgf origen-aaron.pgf origen-meeseeks.pgf nofission*.pgf

# -include *.d
