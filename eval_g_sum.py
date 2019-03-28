#!/usr/bin/env python3
import matplotlib.pyplot as plt
import numpy as np
from scipy.special import spherical_jn as jn
from scipy.special import spherical_yn as nl
from scipy.special import sph_harm as y_sph

import dlmsum

c = 299792458
n_host = 1.


a = 1.
ar1 = np.zeros(2)
ar2 = np.zeros(2)
ar1[0] = a
ar2[1] = a
area=np.abs(ar1[0]*ar2[1]-ar1[1]*ar2[0])  #unit cell surface



#x, y, z = 0.6,0.5,0.001
x, y, z = 0., 0., 0.
rvs = np.sqrt(x**2+y**2+z**2)
R=rvs

# rmuf = 0.481186509
# sigma=2*np.pi*160/(2200*rmuf)
# wl = 2*np.pi*n_host/sigma

wl = a*np.pi*4
sigma = 2*np.pi*n_host/wl 

k=2*np.pi/wl

ak = np.zeros(2)
#ak[0] = k/10.

zgrf = dlmsum.gff2in3(sigma, x,y,z, ak)
print("gff=",zgrf)
lmax = 10
# print(dlmsum.dlsumf2in3.__doc__)

def get_ndend(LMAX):
    K=1
    for L in range(1, 2*LMAX+1+1):
        MM = 1
        if L%2 == 0: MM = 2
        NN=(L-MM)/2+2
        for M in range(MM,L+1,2):
            NN=NN-1
            for I in range(1,int(NN)+1):
                K=K+1
    return K-1

def eval_G(lmax):
    dlm = dlmsum.dlsumf2in3(lmax, sigma+0.j,ak, ar1, ar2)

    lm = 0
    Dsum = 0.+0.j
    for l in range(0,lmax+1):
        # print(l)
        for m in range(-l, +l+1,2):
            # Dsum += dlm[lm]*jn(l,sigma*rvs)*y_sph(m,l, 0., 0.)
            # if np.isclose(0., rvs):
            #     Dsum += dlm[lm]*jn(l,sigma*rvs)
            # else:
            Dsum += dlm[lm]*jn(l,sigma*rvs)*y_sph(m,l, 0., np.pi/2.)
            # if m==-l:
            print("py= (%20.16e,%20.16e)\t"%(np.real(dlm[lm]), np.imag(dlm[lm])),  l, "\t",m,
                  "\t%20.16e"%(jn(l,sigma*rvs)),
                  "\t   %20.16g"%y_sph(m,l, 0., np.pi/2.)
            )
            lm +=1
    #print('nl(0)', nl(0,sigma*rvs)/4.0, -np.cos(sigma*rvs)/(sigma*rvs)/4.)
    # print(-np.exp(1j*sigma*R)/(4.*np.pi*R))
    # print('Dsummm=', Dsum)
    return Dsum+nl(0,sigma*rvs)/4.0, Dsum


# for lmax in range(1,11,1):
#     print('lmax=',lmax,'(G,D)=',eval_G(lmax))
G,Dsum = eval_G(10)
print('lmax=',lmax,'(G,D)=',(G, Dsum))
# print(eval_G(14))

ImG = 2*np.pi*k/area - 2*k**3/3
g1=2*np.pi/a
print("k=",k," g1=",g1, '2k^3/3=',2*k**3/3)
print("ImG=",ImG)
Dscaled = np.imag(Dsum)
print("ratio=",ImG/Dscaled)


# for LMAX in (10, 14, 22, 30,40,50):
#     print(LMAX, get_ndend(LMAX))





#       DO 8 L=1,2*LMAX+1
#       MM=1  
#       IF(MOD  (L,2))7,6,7  
#  6    MM=2  
#  7    NN=(L-MM)/2+2  
# *
#       DO 8 M=MM,L,2  
#       NN=NN-1  
# *
#       DO 8 I=1,NN  
#       DENOM(K)=1.0D0/(FAC(I1)*FAC(I2)*FAC(I3))  
#       K=K+1 
#  8    CONTINUE 
 
