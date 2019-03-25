#!/usr/bin/env python3
import matplotlib.pyplot as plt
import numpy as np

import dlmsum

# c = 299792458
# n_host = 1.
# wl = 0.5 #mkm

x, y, z = 0., 0., 0.
x=0.6
y=0.5
z=0.001


# ar1 = np.zeros(2)
# ar2 = np.zeros(2)
# ar1[0] = 1.
# ar2[1] = 1.

# sigma = 2*np.pi*n_host/wl 

rmuf = 0.481186509
sigma=2*np.pi*160/(2200*rmuf)

ak = np.zeros(2)

zgrf = dlmsum.gff2in3(sigma, x,y,z, ak)
