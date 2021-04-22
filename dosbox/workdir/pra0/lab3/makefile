all: clean Lab3.exe 
Lab3.exe: Lab3.obj Lab3a.obj Lab3b.obj
	tcc -v -ml -Lc:\compila\tc\lib Lab3.obj Lab3a.obj Lab3b.obj
Lab3.obj: Lab3.c
	tcc -c -v -ml -Ic:\compila\tc\include Lab3.c
Lab3a.obj: Lab3a.asm
	tasm /zi /ml Lab3a,, Lab3a
Lab3b.obj: Lab3b.asm
 	tasm /zi /ml Lab3b,, Lab3b 
	 
clean:
	del lab3.exe
	del lab3.obj
	del lab3a.obj
	del lab3a.lst
	del lab3b.obj
	del lab3b.lst