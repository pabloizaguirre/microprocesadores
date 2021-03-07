all: clean alumno.exe
alumno.exe: alumno.obj
	tlink /v alumno
alumno.obj: alumno.asm
	tasm /zi alumno.asm ,, alumno.lst
clean:
	del alumno.obj
	del alumno.exe
	del alumno.map
	del alumno.lst