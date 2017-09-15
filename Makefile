LATEXMK = latexmk
GOOGLE_DRIVE = $(HOME)/Google\ Drive/
TRANSMUTAGEN = $(HOME)/Documents/transmutagen

export PYTHONPATH := $(TRANSMUTAGEN):$(TRANSMUTAGEN)/py_solve

all: paper.pdf

paper.pdf: eigenvals_pwru50.pdf eigenvals_decay.pdf origen-scopatz.pdf origen-aaron.pdf origen-meeseeks.pdf pusa-difference-14.pdf pusa-difference-16.pdf nofission-pwru50-c-solve-1-day.pdf nofission-pwru50-expm-1-day.pdf nofission-pwru50-lambdify-1-day.pdf nofission-pwru50-c-solve-1-million-years.pdf nofission-pwru50-expm-1-million-years.pdf nofission-pwru50-lambdify-1-million-years.pdf nofission-pwru50-c-solve-1-year.pdf nofission-pwru50-expm-1-year.pdf nofission-pwru50-lambdify-1-year.pdf nofission-pwru50-c-solve-1000-years.pdf nofission-pwru50-expm-1000-years.pdf nofission-pwru50-lambdify-1000-years.pdf

%.pdf: %.tex
	$(LATEXMK) -halt-on-error -pdf -M -MP -MF $*.d $*

origen-scopatz.pdf:
	python -m transmutagen.analysis --origen --no-title --origen-results $(GOOGLE_DRIVE)/ERGS\ Private/transmutagen\ data/scopatz_laptop_results_20170508.hdf5 --file origen-scopatz.pdf

origen-aaron.pdf:
	python -m transmutagen.analysis --origen --no-title --origen-results $(GOOGLE_DRIVE)/ERGS\ Private/transmutagen\ data/aaron_laptop_results_20170508.hdf5 --file origen-aaron.pdf

origen-meeseeks.pdf:
	python -m transmutagen.analysis --origen --no-title --origen-results $(GOOGLE_DRIVE)/ERGS\ Private/transmutagen\ data/meeseeks01_results_20170508.hdf5 --file origen-meeseeks.pdf

eigenvals_pwru50.pdf:
eigenvals_decay.pdf:
	python -m transmutagen.analysis --eigenvals --no-title --file eigenvals.pdf --pwru50-data=$(TRANSMUTAGEN)/data/pwru50_400000000000000.0.npz

pusa-difference-14.pdf:
pusa-difference-16.pdf:
	python -m transmutagen.analysis --pusa-coeffs --file pusa-difference.pdf

convergence-14-1000.eps: generate_convergence_plot.py
	python generate_convergence_plot.py

nofission-pwru50-c-solve-1-day.pdf:
nofission-pwru50-expm-1-day.pdf:
nofission-pwru50-lambdify-1-day.pdf:
nofission-pwru50-c-solve-1-million-years.pdf:
nofission-pwru50-expm-1-million-years.pdf:
nofission-pwru50-lambdify-1-million-years.pdf:
nofission-pwru50-c-solve-1-year.pdf:
nofission-pwru50-expm-1-year.pdf:
nofission-pwru50-lambdify-1-year.pdf:
nofission-pwru50-c-solve-1000-years.pdf:
nofission-pwru50-expm-1000-years.pdf:
nofission-pwru50-lambdify-1000-years.pdf:
	python -m transmutagen.analysis --nofission  --file nofission.pdf --no-title

.PHONY: clean
clean:
	$(LATEXMK) -C
	-rm -rf *.ps *.log *.dvi *.aux *.*% *.lof *.lop *.lot *.toc *.idx *.ilg *.ind *.bbl *.blg *.cpt *-diff.tex *.out *.d
	-rm -rf origen-*.pdf eigenvals_*.pdf convergence-14-1000.eps

-include *.d
