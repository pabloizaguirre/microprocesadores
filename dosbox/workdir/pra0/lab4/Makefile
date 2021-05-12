all: clean Lab4a.com lab4b.com Snake.com

Lab4a.com: Lab4a.obj
	tlink /v /t Lab4a
Lab4a.obj: Lab4a.asm
	tasm /zi Lab4a.asm ,, Lab4a.lst

Lab4b.com: Lab4b.obj
	tlink /v Lab4b
Lab4b.obj: Lab4b.asm
	tasm /zi Lab4b.asm ,, Lab4b.lst

Snake.com: Snake.obj
	tlink /v Snake
Snake.obj: Snake.asm
	tasm /zi Snake.asm ,, Snake.lst

clean:
	del Lab4a.obj
	del Lab4a.com
	del Lab4a.map
	del Lab4a.lst
	del Lab4b.obj
	del Lab4b.exe
	del Lab4b.map
	del Lab4b.lst
	del Snake.obj
	del Snake.exe
	del Snake.map
	del Snake.lst