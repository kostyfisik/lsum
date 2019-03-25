# Makefile for chew_rad
# define compiler
CC =           f77
#CC =           gfortran

# define some flags
NAME =         -o $@

#define linker flags
#define linker flags  on SARA:
#LFLAGS =  -lnagblas -lnaggl04 -lnagX11 -lnagaps -lnaggli -lfgl -lgl_s
#-lnagblas  #define linker flags on RUUNAT: -L/usr/local/lib
#LFLAGS =  -lnag 

#define compiler flags   -qautodbl=dblpad           
CFLAGS =  -g  -C

#***************************************************************
# All files needed for the Server and the client

#      include files
#      source files
# SRC = chew_rad.f gnzbess.f gnricbessh.f biga.f zbessf.f bessjy.f\
# bessik.f beschb.f chebev.f bess.f vctharmc.f\
# readmat.f mediumn.f sordalc.f znsrefind.f zartan.f

#      object files
OBJ = beschb.o  bess.o  bessik.o  bessjy.o  dlsumf2in3.o  gff2in3.o\
gnzbess.o chebev.o zbessf.o

# PYSRC = gnzbess.f gnricbessh.f biga.f zbessf.f bessjy.f\
# bessik.f beschb.f chebev.f bess.f vctharmc.f\
# readmat.f mediumn.f sordalc.f znsrefind.f zartan.f chew_mod.f 

#      executable files

.SUFFIXES: .ic .o .c
.f.o:
	$(CC) $(CFLAGS) $(NAME) -c $< 

all:     lsum

lsum: $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o lsum $(LFLAGS) 


# pychew: modchew
# 	f2py3 -c $(PYSRC) -m chew
        
#***************************************************************