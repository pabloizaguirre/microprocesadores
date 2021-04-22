all: clean Lab3b.exe 
Lab3b.exe: Lab3b.obj lab3bs.obj 
	tcc -v -ml -Lc:\compila\tc\lib Lab3b.obj lab3bs.obj 
Lab3b.obj: lab3b.c
	tcc -c -v -ml -Ic:\compila\tc\include lab3b.c
lab3bs.obj: lab3bs.asm
	tasm /zi /ml lab3bs,, lab3bs
	 
clean:
	del lab3b.exe
	del lab3b.obj
	del lab3bs.obj
	del lab3bs.lst
