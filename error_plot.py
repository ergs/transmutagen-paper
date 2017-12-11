import numpy as np
import matplotlib.pyplot as plt

from sympy import exp, lambdify

from transmutagen import get_CRAM_from_cache, t
from transmutagen.analysis import setup_matplotlib_rc

degree = 14

xlims = [-20, 6]
ylims = [-5, 5]

levels = np.arange(-16, 7, 2)

def main():
    setup_matplotlib_rc()

    expr = get_CRAM_from_cache(degree, 200)
    f = lambdify(t, abs(expr - exp(-t)), 'numpy')
    x = np.linspace(*xlims, 1000)
    y = np.linspace(*ylims, 1000)
    xx, yy = np.meshgrid(x, y)
    z = f(-(xx + yy*1j))
    plt.clf()
    # plt.contour(x, y, np.log10(z), levels=levels)
    CS = plt.contourf(x, y, np.log10(z), levels=levels)
    plt.xlim(xlims)
    plt.ylim(ylims)
    axes = plt.gca()
    axes.axhline(y=0, color='k', alpha=.5, linewidth=.5)
    axes.axvline(x=0, color='k', alpha=.5, linewidth=.5)
    # plt.clabel(CS, colors='black', inline=False, fmt='%d')
    plt.colorbar(CS,
        format=r'$10^{%d}$',
        # ticks=levels,
        )
    plt.ylabel('real axis')
    plt.xlabel('imaginary axis')

    # TODO: Why won't pgf work?
    plt.savefig('error-plot.pdf')

if __name__ == '__main__':
    main()
