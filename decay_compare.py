#!/usr/bin/env python
from pprint import pprint
from collections import defaultdict

import numpy as np
import matplotlib.pyplot as plt

from pyne import nucname
from pyne.material import Material
from pyne import cram

from transmutagen.origen_all import TIME_STEPS


np.set_printoptions(precision=18)

TIMES = [0.0] + sorted(TIME_STEPS.keys())
NTIMES = len(TIMES)
DECAY_MATS = {t: (-cram.DECAY_MATRIX*t) for t in TIME_STEPS}

emptytime = lambda: np.zeros(NTIMES, dtype=float)


def run_nuclide(nuc):
    bateman = defaultdict(emptytime)
    bateman[nuc][0] = 1
    crammed = defaultdict(emptytime)
    crammed[nuc][0] = 1
    n0 = Material({nuc: 1.0}, mass=1.0, atoms_per_molecule=1.0)
    for i, t in enumerate(TIMES[1:], 1):
        b1 = n0.decay(t).to_atom_frac()
        for key, val in b1.items():
            n = nucname.name(key)
            bateman[n][i] = val
        c1 = n0.cram(DECAY_MATS[t], order=16).to_atom_frac()
        for key, val in c1.items():
            n = nucname.name(key)
            crammed[n][i] = val
    return bateman, crammed


def diff_nuclide(a, b):
    d = defaultdict(emptytime)
    for nuc in a:
        d[nuc] = a[nuc] - b[nuc]
    for nuc in b:
        if nuc not in a:
            d[nuc] = -b[nuc]
    return d


if __name__ == '__main__':
    print(TIMES)
    nuc = 'U235'
    b, c = run_nuclide('U235')
    print('Bateman:')
    pprint(b[nuc])
    print('CRAM')
    pprint(c[nuc])
    print('Diff')
    pprint(diff_nuclide(b,c)[nuc])

