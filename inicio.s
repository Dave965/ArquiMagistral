.global main

main:
ldr r0, =filename_format
ldr r1, =file
bl scanf
bl printf




svc 0



.data
encabezado .asciz   "Lista de puntos:\n"
par_ordenado .asciz "(%d,%d)\n"
filename_format .asciz "%s"
file .word 10