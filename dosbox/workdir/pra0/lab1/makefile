all: clean Lab1A.exe 

Lab1A.exe: Lab1A.obj
	tlink /v Lab1A
Lab1A.obj: Lab1A.asm
	tasm /zi Lab1A.asm ,, Lab1A.lst
	
Lab1B.exe: Lab1B.obj
	tlink /v Lab1B
Lab1B.obj: Lab1B.asm
	tasm /zi Lab1B.asm ,, Lab1B.lst

clean:
	del Lab1A.obj
	del Lab1A.exe
	del Lab1A.map
	del Lab1A.lst
	del Lab1B.obj
	del Lab1B.exe
	del Lab1B.map
	del Lab1B.lst