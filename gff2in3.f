      subroutine GFF2IN3(sigma, x, y, z, AK, zgrf )
c$$$      PROGRAM GFF2IN3
C--------/---------/---------/---------/---------/---------/---------/--
C >>> SIGMA,SCALE,LMAX,NCMB,B
C <<< ZGRF
C
C  Generates the lattice and spherical harmonics and helps you to obtain
C  the free-space Green's function given the the total lattice sum D_L 
C  generated by either dlsumf2in3.f for a simple Bravais lattice or 
C  by dlmset together with dlmsf2in3 for a complex Bravais lattice (=)
C
C  Dependent routines
C
C      1) either dlsumf2in3.f or dlmset together with dlmsf2in3 
C         generating  
C
C      2) gncbess(comega,lmax,jl,djl,nl,dnl) generates arrays of
C         spherical Bessel functions and their derivatives
C
C      3) ZSPHAR(L,X,Y,Z,ZLM) returns complex spherical harmonics 
C         in the Condon-Shortley convention
C
C       The atan() function returns the arc tangent in radians and
C       the  value  is  mathematically defined to be between -PI/2
C       and PI/2 (inclusive). 
C--------/---------/---------/---------/---------/---------/---------/--
      IMPLICIT NONE 
      INTEGER LBESS,LMAX,lmaxp1, lmaxdp1,NYLR,NYLRD,NCMB,NFM,
     & LMAXD,LMDLMD,LMDL,ISTEP, LMTD,LMTT, dlmaxdp1
c$$$      logical complex
*::: cutoff on bessel functions
      PARAMETER (ISTEP=1)
*::: cutoff on bessel functions
      PARAMETER (LBESS=10)
*::: actual cutoff on spherical functions
      PARAMETER (LMAX=10)
      PARAMETER (LMAXP1=LMAX+1)
*::: macximal cutoff on spherical functions
      PARAMETER (LMAXD=10)
      PARAMETER (LMAXDP1=LMAXD+1)
*     
      PARAMETER (NYLR=LMAXP1**2)
      PARAMETER (NYLRD=LMAXDP1**2)
      PARAMETER (LMTD=NYLRD-1)
      PARAMETER (LMTT=2*LMTD)
      PARAMETER (LMDLMD=LMAXP1*(2*LMAX+1))
      PARAMETER (dlmaxdp1=2*LMAXD+1)
      PARAMETER (LMDL=dlmaxdp1**2)
*::: cutoff on the number of scatterers per primitive cell
      PARAMETER (NCMB=2)
      PARAMETER (NFM=NCMB*NCMB-NCMB+1)
*::: if complex lattice than complex.eq.true., else complex.eq.false.
c$$$      PARAMETER (complex=.true.)
*
      integer ib,ilb,ilm,l,lmt,m,ist,ifl,nbas
      real*8 sigma
Cf2py intent(in) sigma      
      real*8 AK(2)
Cf2py intent(in) AK
      real*8 x,y,z
Cf2py intent(in) x
Cf2py intent(in) y
Cf2py intent(in) z
      
      real*8 xtol,xxtol,pi,rvs,b1(2),b2(2),
     1 a0,ra0,rmuf
      COMPLEX*16 zgrf
Cf2py intent(out) zgrf
      
      COMPLEX*16 zgrt,comega,csigma,ci
      COMPLEX*16 B(LMDLMD,NCMB),DLM(LMDL,NFM),XMAT(NYLRD,NYLRD,NFM) 
      COMPLEX*16 VEC(LMTT,LMTT,NFM) 
      COMPLEX*16 JL(0:lbess),NL(0:lbess),DJL(0:lbess),DNL(0:lbess)
      COMPLEX*16 ZLM(-LMAX:LMAX),YL(NYLR)
*
      REAL*8 AR1(2)
      REAL*8  AR2(2)                    ! 2D DIRECT-LATTICE BASIS VECTORS
Cf2py intent(in) AR1
Cf2py intent(in) AR2
c$$$      common/x1/      ar1,ar2         !direct lattice basis vectors
c$$$      common/xin/     b1,b2           !reciprocal lattice basis vectors
c$$$      common/xar/     a0              !unit cell area
*
      DATA PI/3.141592653589793d0/
      DATA CI/(0.0D0,1.0D0)/
*
C      if(.not.complex) go to 1
C  
C****** DEFINE THE 2D DIRECT AND RECIPROCAL-LATTICE VECTORS ******  
C
      AR1(1)=1.d0                      ! (100) sc
      AR1(2)=0.d0 
      AR2(1)=0.d0 
      AR2(2)=1.d0 
c$$$      AR1(1)=1.d0 
c$$$      AR1(2)=0.d0 
c$$$      AR2(1)=cos(pi/3.d0)               ! (111) fcc
c$$$      AR2(2)=cos(pi/6.d0)
c$$$      write(6,*)'ar2=',ar2
c$$$      write(6,*)'ar1=',ar1
      
      A0=ABS(AR1(1)*AR2(2)-AR1(2)*AR2(1))  
      RA0=2.D0*PI/A0  
      B1(1)=-AR1(2)*RA0  
      B1(2)= AR1(1)*RA0  
      B2(1)=-AR2(2)*RA0  
      B2(2)= AR2(1)*RA0  
*
      if(a0.eq.0.) then
       write(6,*)'In gff2in3.f:'
       write(6,*)'Wrong choice of lattice basis vectors AR1, AR2!'
       stop
      end if
*

  1   do 100 IST=1,ISTEP    !loop only to test the speed of execution
*
* checking set up
      if (lmax.gt.lbess) then
      write(6,*)'Raise the value of LBESS in GFF2IN3'
      write(6,*)'Should be LBESS.GE.LMAX'
      stop
      end if
*
c      write(6,*)'Read in sigma'
c      read(5,*) sigma
c      sigma=2.d0*pi
c      sigma=2.2d0
*
c      write(6,*)'Read in the x-component of parallel momentum'
c      read(5,*) AK(1)
c      AK(1)=sigma*sin(pi/4.d0)
*
c      write(6,*)'Read in the y-component of parallel momentum'
c      read(5,*) AK(2)
*
*
      rmuf= 0.481186509d0
c$$$      sigma=2.d0*pi*160.d0/(2200.d0*rmuf)
c$$$      x=0.6d0
c$$$      y=0.5d0
c$$$      z=0.001d0
c$$$      AK(1)=0.0d0
c$$$      AK(2)=0.0d0

      csigma=dcmplx(sigma,0.d0)
*
c$$$      write(6,*)'sigma=',csigma
c$$$      write(6,*)'ak=',ak
c$$$      write(6,*)'ar1=',ar1
c$$$      write(6,*)'ar2=',ar2
      call dlsumf2in3(lmax,csigma,ak, AR1, AR2, b)
      
      
*
*
cd      nbas=1
cd      call dlmset(lmax)
cd      call dlmsf2in3(lmax,nbas,csigma,ak,dlm) 
*
cc      do ifl=1,nfm
cc      call blf2in3(lmax,xmat(1,1,ifl),dlm(1,ifl))
*
cc      if (ifl.eq.1) then     !make G_{LL'} from A_{LL'}
cc       xmat(1,1,1)=xmat(1,1,1)+ci*csigma
cc      end if
*       
cc      call GEN2IN3VEC(LMAX,XMAT(1,1,ifl),VEC(1,1,ifl))
cc      enddo
*
*
c      call secular(nlb,nbas,inmax2,tmt,vec,ama) 
*
c      do 100 IST=1,ISTEP
*
*
      rvs=sqrt(x**2+y**2+z**2)
*
      YL(1)=1.d0/sqrt(4.d0*pi)
*
      do l=1,lmax
c$$$      write(6,*)'l = ',l
      lmt=l**2
      CALL ZSPHAR(L,X,Y,Z,ZLM)
C--------------------------------------------------------------------
* ==============
*  This routine returns complex spherical harmonics in the 
*  Condon-Shortley convention and identical to those in 
*  Ligand Field Theory by C. J. Ballhausen.
*
*  A problem occurs in the calling routine if lmax=0 since locally it
*  assumes that dim of ZLM(-LMAX:LMAX)=0
*      
*      LTOT               Intrinsic bound on the maximal angular momentum
*      LMAX               Maximal angular momentum in the calling program
*      alpha,beta,gamma   Euler angles
*      x,y,z              cartesian coordinates    
*      ZLM                real spherical harmonics in the original system
C--------/---------/---------/---------/---------/---------/---------/-- 
        do m=-lmax,-lmax+2*l
          YL(lmt+lmax+m+1)=ZLM(m)
        enddo
      enddo
*
      comega=dcmplx(sigma*rvs,0.d0)
      call gnzbess(comega,lmax,jl,djl,nl,dnl)
*
******************    Summation     *******************
      zgrf=(0.d0,0.d0)
*
      ib=1
      ilm=0
*
*  Green's function via lattice sums:
*
      DO 5 ILB=0,LBESS   ! summation over l's
      zgrt=(0.d0,0.d0)
*
      do m=-ilb,ilb,2
      ilm=ilm+1
      lmt=ilb**2+ilb
      zgrt=zgrt+B(ilm,IB)*yl(lmt+m+1)
      write(6,*)'b = ',B(ilm,IB), ILB, m, "yl=", yl(lmt+m+1)
      
      enddo
*
      write(6,*)'asr ',B(ilm,IB),ILM,IB, ILB, jl(ilb)
      zgrf=zgrf+zgrt*jl(ilb)
c$$$      write(6,*)'zgrf = ',zgrf

*
 5    CONTINUE
*
      write(6,*)'Dsum=',zgrf
      zgrf=nl(0)/4.d0+zgrf
c$$$      write(6,*)'nl0 = ',nl(0)/4.d0

*
c$$$      write(6,*)'Green function=',zgrf
*
 100  CONTINUE
*
*--------/---------/---------/---------/---------/---------/---------/--
      end
C (C) Copr. 08/2001  Alexander Moroz
