#!/usr/bin/env python
from pprint import pprint
from collections import defaultdict

import numpy as np
import matplotlib.pyplot as plt
from sympy import exp

from pyne import nucname
from pyne.material import Material
from pyne import cram

from transmutagen.origen_all import TIME_STEPS


np.set_printoptions(precision=18)

#TIMES = [0.0] + sorted(TIME_STEPS.keys())
TIMES = [0.0] + np.logspace(1, 14, 27).tolist()
NTIMES = len(TIMES)
DECAY_MATS = {t: (-cram.DECAY_MATRIX*t) for t in TIMES}

emptytime = lambda: np.zeros(NTIMES, dtype=float)


def run_nuclide(nuc):
    bateman = defaultdict(emptytime)
    bateman[nuc][0] = 1
    crammed = defaultdict(emptytime)
    crammed[nuc][0] = 1
    diagexp = defaultdict(emptytime)
    diagexp[nuc][0] = 1
    n0 = Material({nuc: 1.0}, mass=1.0, atoms_per_molecule=1.0)
    for i, t in enumerate(TIMES[1:], 1):
        # compute Bateman
        try:
            b1 = n0.decay(t).to_atom_frac()
        except RuntimeError:
            # decay can't handle all of the same nuclides CRAM can
            b1 = {}
        for key, val in b1.items():
            n = nucname.name(key)
            bateman[n][i] = val
        # compute CRAM
        c1 = n0.cram(DECAY_MATS[t], order=16).to_atom_frac()
        for key, val in c1.items():
            n = nucname.name(key)
            crammed[n][i] = val
        # compute e^x of the diagonal of the decay matrix, ie the nuc itself
        nuc_idx = cram.NUCS_IDX[nuc]
        mat_idx = cram.IJ[nuc_idx, nuc_idx]
        diagexp[nuc][i] = exp(-DECAY_MATS[t][mat_idx]).evalf(n=30)
    return bateman, crammed, diagexp


def diff_nuclide(a, b, abs=False, include_missing=True):
    d = defaultdict(emptytime)
    for nuc in a:
        if nuc in b or include_missing:
            d[nuc] = a[nuc] - b[nuc]
    if include_missing:
        for nuc in b:
            if nuc not in a:
                d[nuc] = -b[nuc]
    if abs:
        for nuc in d:
            d[nuc] = np.abs(d[nuc])
    return d


def run_nuclides(nucs=None, verbose=True):
    batemans = {}
    crammeds = {}
    diagexps = {}
    nucs = cram.NUCS if nucs is None else nucs
    for nuc in nucs:
        print('Running nuc ' + nuc)
        b, c, d = run_nuclide(nuc)
        batemans[nuc] = b
        crammeds[nuc] = c
        diagexps[nuc] = d
    return batemans, crammeds, diagexps


if __name__ == '__main__':
    print(TIMES)
    nuc = 'H3'
    b, c, d = run_nuclide('H3')
    print('Bateman:')
    pprint(b[nuc])
    print('Decay Exponentional:')
    pprint(d[nuc])
    print('CRAM')
    pprint(c[nuc])
    print('Diff')
    pprint(diff_nuclide(d,c)[nuc])

