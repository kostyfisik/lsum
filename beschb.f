      SUBROUTINE beschb(x,gam1,gam2,gampl,gammi)
c--------/---------/---------/---------/---------/---------/---------/--
c Modified to a double precision subroutine Aug. 17, 1998
c Evaluates 
C          gam1=\fr{1}{2\nu} [\Gamma^{-1}(1-\nu)-\Gamma^{-1}(1+\nu)]
C          gam2=  \fr{1}{2}  [\Gamma^{-1}(1-\nu)+\Gamma^{-1}(1+\nu)]
c by Chebyshev expansion for |x|\leq 2
c by Chebyshev expansion for |x|\leq 1/2. Also returns \Gamma^{-1}(1-\nu)
c and \Gamma^{-1}(1+\nu)
c--------/---------/---------/---------/---------/---------/---------/--
      INTEGER NUSE1,NUSE2
      DOUBLE PRECISION gam1,gam2,gammi,gampl,x
      PARAMETER (NUSE1=7,NUSE2=8)
CU    USES chebev
      REAL*8 xx,c1(7),c2(8),chebev
      SAVE c1,c2
      DATA c1/-1.142022680371172d0,6.516511267076d-3,3.08709017308d-4,
     *-3.470626964d-6,6.943764d-9,3.6780d-11,-1.36d-13/
      DATA c2/1.843740587300906d0,-.076852840844786d0,1.271927136655d-3,
     *-4.971736704d-6,-3.3126120d-8,2.42310d-10,-1.70d-13,-1.d-15/
      xx=8.d0*x*x-1.d0
      gam1=chebev(-1.d0,1.d0,c1,NUSE1,xx)
      gam2=chebev(-1.d0,1.d0,c2,NUSE2,xx)
      gampl=gam2-x*gam1
      gammi=gam2+x*gam1
      return
      END
C  (C) Copr. 1986-92 Numerical Recipes Software