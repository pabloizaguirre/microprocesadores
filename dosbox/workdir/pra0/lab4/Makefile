all: clean Lab4a.com Lab4.exe lab4b.com

Lab4a.com: Lab4a.obj
	tlink /v /t Lab4a
Lab4a.obj: Lab4a.asm
	tasm /zi Lab4a.asm ,, Lab4a.lst

Lab4b.com: Lab4b.obj
	tlink /v Lab4b
Lab4b.obj: Lab4b.asm
	tasm /zi Lab4b.asm ,, Lab4b.lst

Lab4.exe: Lab4.obj
	tlink /v Lab4
Lab4.obj: Lab4.asm
	tasm /zi Lab4.asm ,, Lab4.lst

clean:
	del Lab4a.obj
	del Lab4a.com
	del Lab4a.map
	del Lab4a.lst
	del Lab4b.obj
	del Lab4b.com
	del Lab4b.map
	del Lab4b.lst
	del Lab4.obj
	del Lab4.exe
	del Lab4.map
	del Lab4.lst