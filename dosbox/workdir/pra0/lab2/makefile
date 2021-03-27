all: clean Lab2A.exe Lab2B.exe

Lab2A.exe: Lab2A.obj
	tlink /v Lab2A
Lab2A.obj: Lab2A.asm
	tasm /zi Lab2A.asm ,, Lab2A.lst
Lab2B.exe: Lab2B.obj
	tlink /v Lab2B
Lab2B.obj: Lab2B.asm
	tasm /zi Lab2B.asm ,, Lab2B.lst

clean:
	del Lab2A.obj
	del Lab2A.exe
	del Lab2A.map
	del Lab2A.lst
	del Lab2B.obj
	del Lab2B.exe
	del Lab2B.map
	del Lab2B.lst