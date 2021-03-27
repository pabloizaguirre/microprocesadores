all: clean test1.exe 

test1.exe: test1.obj
	tlink /v test1
test1.obj: test1.asm
	tasm /zi test1.asm ,, test1.lst

clean:
	del test1.obj
	del test1.exe
	del test1.map
	del test1.lst