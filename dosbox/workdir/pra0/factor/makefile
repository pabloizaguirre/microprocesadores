all: clean factor.exe
factor.exe: factor.obj
	tlink /v factor
factor.obj: factor.asm
	tasm /zi factor.asm ,, factor.lst
clean:
	del factor.obj
	del factor.exe
	del factor.map