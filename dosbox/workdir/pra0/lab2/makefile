all: clean Lab2A.exe

Lab2A.exe: Lab2A.obj
	tlink /v Lab2A
Lab2A.obj: Lab2A.asm
	tasm /zi Lab2A.asm ,, Lab2A.lst
clean:
	del Lab2A.obj
	del Lab2A.exe
	del Lab2A.map
	del Lab2A.lst