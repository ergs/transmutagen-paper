#!/usr/bin/env python
from transmutagen import get_CRAM_from_cache, t, plot_in_terminal

from sympy import Poly, fraction, exp
import matplotlib.pyplot as plt

degree = 14
prec = 200
points = 1000

def main():
    from matplotlib import rcParams
    rcParams['pgf.texsystem'] = 'pdflatex'
    rcParams["text.usetex"] = True

    expr = get_CRAM_from_cache(degree, prec)

    c = 0.6*degree

    # Get the translated approximation on [-1, 1]. This is similar logic from CRAM_exp().
    n, d = map(Poly, fraction(expr))
    inv = -c*(t + 1)/(t - 1)
    p, q = map(lambda i: Poly(i, t), fraction(inv))
    n, d = n.transform(p, q), d.transform(p, q)
    rat_func = n/d.TC()/(d/d.TC())
    rat_func = rat_func.evalf(prec)

    plt.clf()
    fig, (ax1, ax2) = plt.subplots(1, 2, sharey=False)
    fig.set_size_inches(1.5*6.4, 1.5/2*4.8)

    plot_in_terminal(rat_func - exp(-inv), (-1, 1), prec=prec, points=points,
        axes=ax1)
    ax1.set_xlabel(r'$t$')
    ax1.set_ylabel(r'$\hat{r}_{14, 14}\left (c\frac{t+1}{t-1}\right ) - e^{-c\frac{t+1}{t-1}}$')

    plot_in_terminal(expr - exp(-t), (0, 100), prec=prec, points=points,
        axes=ax2)
    ax2.set_xlabel(r'$t$')
    ax2.set_ylabel(r'$\hat{r}_{14, 14}(t) - e^{-t}$')

    plt.tight_layout()
    plt.savefig('cram-plot.pgf')

if __name__ == '__main__':
    main()
