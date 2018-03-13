LATEXMK = latexmk
GOOGLE_DRIVE ?= $(HOME)/Google\ Drive/
TRANSMUTAGEN_DATA ?= $(GOOGLE_DRIVE)/ERGS\ Private/transmutagen\ data/
TRANSMUTAGEN ?= $(HOME)/Documents/transmutagen
LATEXMK_FLAGS =

export PYTHONPATH := $(TRANSMUTAGEN):$(TRANSMUTAGEN)/py_solve

all: paper.pdf

.PHONY: continuous
continuous: LATEXMK_FLAGS += -pvc -view=none
continuous: paper.pdf

paper.pdf: origen-scopatz.pgf origen-aaron.pgf eigenvals_pwru50.pdf eigenvals_decay.pdf pusa-table-14.tex pusa-table-16.tex pusa-differences.pgf pusa-differences-errors-14.pgf pusa-differences-errors-16.pgf convergence-14-1000.pgf cram-plot.pgf error-plot.pdf degrees.pgf nofission-pwru50-1-day.pgf nofission-pwru50-1-year.pgf nofission-pwru50-1000-years.pgf nofission-pwru50-1-million-years.pgf lu-solve-ordering.pdf *.tex paper.bib

%.pdf: %.tex
	$(LATEXMK) -lualatex -interaction=nonstopmode -use-make -f $(LATEXMK_FLAGS) $*

origen-scopatz.pgf:
	python -m transmutagen.analysis --origen --no-title --origen-results $(TRANSMUTAGEN_DATA)/scopatz_laptop_results_20170508.hdf5 --file origen-scopatz.pgf

origen-aaron.pgf:
	python -m transmutagen.analysis --origen --no-title --origen-results $(TRANSMUTAGEN_DATA)/aaron_laptop_results_20171212.hdf5 --file origen-aaron.pgf

origen-meeseeks.pgf:
	python -m transmutagen.analysis --origen --no-title --origen-results $(TRANSMUTAGEN_DATA)/meeseeks01_results_20171211.hdf5 --file origen-meeseeks.pgf

eigenvals_pwru50.pdf eigenvals_decay.pdf:
	python -m transmutagen.analysis --eigenvals --no-title --file eigenvals.pdf

pusa-table-14.tex pusa-table-16.tex pusa-differences.pgf pusa-differences-errors-14.pgf pusa-differences-errors-16.pgf:
	python -m transmutagen.analysis --pusa-coeffs --file pusa-differences.pgf --latex pusa-table.tex

convergence-14-1000.pgf: generate_convergence_plot.py
	python generate_convergence_plot.py

cram-plot.pgf: cram_plot.py
	python cram_plot.py

error-plot.pdf: error_plot.py
	python error_plot.py

degrees.pgf:
	python -m transmutagen.analysis --degrees --file degrees.pgf

nofission-pwru50-1-day.pgf nofission-pwru50-1-year.pgf nofission-pwru50-1000-years.pgf nofission-pwru50-1-million-years.pgf:
	if [ ! -d "$(TRANSMUTAGEN)/py_solve" ]; then echo "py_solve not found. If the following errors, set the TRANSMUTAGEN environment variable to the root transmutagen git repo."; fi
	python -m transmutagen.gensolve --py-solve -o $(TRANSMUTAGEN)/py_solve/py_solve/solve.c
	python $(TRANSMUTAGEN)/py_solve/setup.py build_ext --inplace
	python -m transmutagen.analysis --nofission  --file nofission.pgf

lu-solve-ordering.pdf:
	python -m transmutagen.analysis --lusolve --file lu-solve-ordering.pdf

.PHONY: clean
clean:
	$(LATEXMK) -C
	-rm -rf *.ps *.log *.dvi *.aux *.*% *.lof *.lop *.lot *.toc *.idx *.ilg *.ind *.bbl *.blg *.cpt *-diff.tex *.out *.d
	-rm -rf origen-*.pdf eigenvals_*.pdf convergence-14-1000.pgf pusa-differences.pgf origen-scopatz.pgf origen-aaron.pgf origen-meeseeks.pgf nofission*.pgf cram-plot.pgf error-plot.pdf lu-solve-ordering.pdf
