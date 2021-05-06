all: clean Lab4a.exe Lab4.exe

Lab4a.exe: Lab4a.obj
	tlink /v /t Lab4a
Lab4a.obj: Lab4a.asm
	tasm /zi Lab4a.asm ,, Lab4a.lst

Lab4.exe: Lab4.obj
	tlink /v Lab4
Lab4.obj: Lab4.asm
	tasm /zi Lab4.asm ,, Lab4.lst

clean:
	del Lab4a.obj
	del Lab4a.exe
	del Lab4a.map
	del Lab4a.lst
	del Lab4.obj
	del Lab4.exe
	del Lab4.map
	del Lab4.lst