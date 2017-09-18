#!/usr/bin/env python
from sympy import Float, log

import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter, Locator


# Extracted from the log of
# python -m transmutagen.cram 14 1000
maxmins = list(map(Float, [
    '3.96943889991945e-13',
    '1.53753134519093e-13',
    '4.30975380325089e-14',
    '5.95097393948164e-15',
    '2.32876542970252e-16',
    '1.88312656024333e-19',
    '2.51052376329479e-25',
    '2.67458735050441e-37',
    '3.69398113985317e-61',
    '6.50610893222295e-109',
    '2.39899890746274e-204',
    '3.66559367831934e-395',
    '5.59119748140541e-777',
    '4.68095360529445e-1000',
    ]))
degree = 14
prec = 1000

def generate_plot():
    from matplotlib import rcParams
    rcParams['pgf.texsystem'] = 'pdflatex'
    rcParams["text.usetex"] = True

    iteration = len(maxmins)

    fig, ax = plt.subplots()
    ax.plot(range(1, iteration+1), [log(i, 10) for i in maxmins], linestyle='-', marker='o')

    # Log scale the y-axis, in a way that works even for large values.
    # See https://stackoverflow.com/questions/44211066/matplotlib-log-scale-for-values-too-small-for-floating-point.
    def log_formatter(x, pos):
        return "$10^{{{:d}}}$".format(int(x))
    formatter = FuncFormatter(log_formatter)
    ax.yaxis.set_major_formatter(formatter)

    # enable log sub-ticks
    class LogMinorLocator(Locator):
        def __call__(self):
            import numpy as np
            majorlocs = self.axis.get_majorticklocs()
            step = majorlocs[1] - majorlocs[0]
            res = majorlocs[:, None] + np.log10(np.linspace(1, 0.1, 10)) * step
            return res.ravel()
    ax.yaxis.set_minor_locator(LogMinorLocator())

    ax.set_xticks(range(1, iteration+1))
    plt.xlabel("Iteration")
    plt.ylabel(r"$\varepsilon_N = \max{|z_i|} - \min{|z_i|}$")
    # plt.title("Convergence for degree %s, %s digits precision" % (degree, prec))
    plt.savefig('convergence-14-1000.pgf', format='pgf', dpi=1000)

if __name__ == '__main__':
    generate_plot()
