all: clean vgaddga.exe Lab3.exe

vgaddga.exe: vgaddga.obj
	tlink /v vgaddga
vgaddga.obj: vgaddga.asm
	tasm /zi vgaddga.asm ,, vgaddga.lst

Lab3.exe: Lab3.obj Lab3a.obj
	tcc -v -ml -Lc:\compila\tc\lib Lab3.obj Lab3a.obj
Lab3.obj: Lab3.c
	tcc -c -v -ml -Ic:\compila\tc\include Lab3.c
Lab3a.obj: Lab3a.asm
	tasm /zi /ml Lab3a.asm,, Lab3a.lst

clean:
	del vgaddga.obj
	del vgaddga.exe
	del vgaddga.map
	del vgaddga.lst
	del lab3.obj
	del lab3a.obj
	del lab3a.exe
	del lab3a.map
	del lab3a.lst

# all: Lab3.exe
# Lab3.exe: Lab3.obj Lab3a.obj
# 	tcc -v -ml -Lc:\compila\tc\lib Lab3.obj Lab3a.obj
# Lab3.obj: Lab3.c
# 	tcc -c -v -ml -Ic:\compila\tc\include Lab3.c
# Lab3a.obj: Lab3a.asm
# 	tasm /zi /ml Lab3a.asm,, Lab3a.lst