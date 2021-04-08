all: clean Lab2D.exe 

Lab2D.exe: Lab2D.obj
	tlink /v Lab2D
Lab2D.obj: Lab2D.asm
	tasm /zi Lab2D.asm ,, Lab2D.lst

clean:
	del Lab2D.obj
	del Lab2D.exe
	del Lab2D.map
	del Lab2D.lst