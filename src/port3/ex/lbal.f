C$TEST LBAL
C***********************************************************************
C
C  EXAMPLE OF USE OF THE PORT PROGRAM BALU
C
C***********************************************************************
       SUBROUTINE BADET(N,ML,M,A,IA,DETMAN,IDETEX)
C
C THIS SUBROUTINE COMPUTES THE DETERMINANT OF A
C BANDED MATRIX STORED IN PACKED FORM IN A
C THE DETERMINANT IS COMPUTED AS DETMAN*BETA**IDETEX,
C WHERE BETA IS THE BASE OF THE MACHINE AND
C DETMAN IS BETWEEN 1/BETA AND 1 IN ABSOLUTE VALUE
C
       INTEGER ML, M, N, IA, IDETEX
       INTEGER E, ISPAC, IALOW, ISTKGT, ISIGN, INTER, I, MU
       INTEGER IN(1000)
       REAL A(IA,1), DETMAN, BETA, ONOVBE, S
       REAL R(1000)
       DOUBLE PRECISION D(500)
       COMMON /CSTAK/D
       EQUIVALENCE(D(1),R(1)),(D(1),IN(1))
C
C ALLOCATE SPACE FROM THE STACK FOR THE PIVOT ARRAY
C AND THE EXTRA SPACE TO HOLD THE LOWER TRIANGLE
C
       ISPAC=(ML-1)*N
       IALOW=ISTKGT(ISPAC,3)
       INTER=ISTKGT(N,2)
       CALL BALU(N,ML,M,A,IA,R(IALOW),ML-1,IN(INTER),MU,0.0)
C
C THE DETERMINANT IS THE PRODUCT OF THE ELEMENTS OF
C ROW 1 OF A TIMES THE LAST ELEMENT IN THE ARRAY INTER.
C WE TRY TO COMPUTE THIS PRODUCT IN A WAY THAT WILL
C AVOID UNDERFLOW AND OVERFLOW.
C
       BETA=FLOAT(I1MACH(10))
       ONOVBE=1.0/BETA
       ISIGN=INTER+N-1
       DETMAN=IN(ISIGN)*ONOVBE
       IDETEX=1
       DO 10 I=1,N
          CALL UMKFL(A(1,I),E,S)
          DETMAN=DETMAN*S
          IDETEX=IDETEX+E
          IF (ABS(DETMAN).GE.ONOVBE) GO TO 10
             IDETEX=IDETEX-1
             DETMAN=DETMAN*BETA
   10   CONTINUE
        CALL ISTKRL(2)
        RETURN
        END