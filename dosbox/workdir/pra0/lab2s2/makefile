all: clean Lab2D.exe Lab2E.exe 

Lab2D.exe: Lab2D.obj
	tlink /v Lab2D
Lab2D.obj: Lab2D.asm
	tasm /zi Lab2D.asm ,, Lab2D.lst

Lab2E.exe: Lab2E.obj
	tlink /v Lab2E
Lab2E.obj: Lab2E.asm
	tasm /zi Lab2E.asm ,, Lab2E.lst

clean:
	del Lab2D.obj
	del Lab2D.exe
	del Lab2D.map
	del Lab2D.lst
	del Lab2E.obj
	del Lab2E.exe
	del Lab2E.map
	del Lab2E.lst