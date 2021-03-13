all: clean Lab1C.exe Lab1A.exe Lab1b.exe 

Lab1A.exe: Lab1A.obj
	tlink /v Lab1A
Lab1A.obj: Lab1A.asm
	tasm /zi Lab1A.asm ,, Lab1A.lst
	
Lab1B.exe: Lab1B.obj
	tlink /v Lab1B
Lab1B.obj: Lab1B.asm
	tasm /zi Lab1B.asm ,, Lab1B.lst

Lab1C.exe: Lab1C.obj
	tlink /v Lab1C
Lab1C.obj: Lab1C.asm
	tasm /zi Lab1C.asm ,, Lab1C.lst

clean:
	del Lab1A.obj
	del Lab1A.exe
	del Lab1A.map
	del Lab1A.lst
	del Lab1B.obj
	del Lab1B.exe
	del Lab1B.map
	del Lab1B.lst
	del Lab1C.obj
	del Lab1C.exe
	del Lab1C.map
	del Lab1C.lst