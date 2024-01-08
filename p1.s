


.global main

main:
LDR R0, =txt_escribir
BL printf

LDR R0, =formato_nombre
LDR R1, =archivo_entrada
BL scanf

LDR R0, =archivo_entrada
MOV R1, #0
MOV R2, #0
MOV R7, #5
SVC 0

MOV R4, #0 
MOV R5, #0

leer_caracter:
PUSH {R0, R4, R5}     

LDR R1, =buffer_ascii
MOV R2, #1            
MOV R7, #3
SVC 0

POP {R0, R4, R5} 

LDRB R3, [R1], #1
CMP R3, #36
BEQ end
CMP R3, #10
BEQ enter

SUB R3, #48 
MOV R2, #10
MUL R4, R2  
ADD R4, R3
B leer_caracter

enter:
ADD R5, #1
STR R4, [SP]
MOV R4, #0
SUB SP, #4
B leer_caracter


end:
LSR R5, #1
STR R5, [SP]

LDR R0, =salto_linea
BL printf

MOV R0, #1
LDR R2, [SP]

calculo_num_clusters:
MUL R1, R0, R0
CMP R1, R2
bgt instanciar_clusters
ADD R0, #1
B calculo_num_clusters

instanciar_clusters:
SUB R0, #1
ADD SP, #4

MOV R3, #4
MUL R3, R2
ADD R3, #12
MUL R3, R0
SUB SP, R3
SUB SP, #4
STR R2, [SP]
SUB SP, #4
STR R0, [SP]


MOV R2, #0
MOV R3, #0



iniciar_clusters:
LDR R0, [SP]
LDR R1, [SP,#4]
MOV R4, #4
SUB R0, R2
MUL R4, R1
ADD R4, #12
MUL R4, R0
ADD R4, #4


LDR R0, [SP]
MOV R6, #8
MOV R5, #4
MUL R5, R1
ADD R5, #12
MUL R5, R0 
SUB R1, R3 
MUL R1, R6
ADD R5, R1 
ADD R5, #4


LDR R0, [SP, R5] 
STR R0, [SP, R4] 
SUB R5, #4
SUB R4, #4
LDR R0, [SP, R5] 
STR R0, [SP, R4] 
SUB R4, #4
MOV R0, #1
STR R0, [SP, R4] 
SUB R4, #4
STR R3, [SP, R4] 
ADD R2, #1
ADD R3, #1

LDR R0, [SP]
CMP R2, R0
BEQ set_ultimo_cluster
B iniciar_clusters

set_ultimo_cluster:
SUB R2, #1
SUB R3, #1

loop_ultimo_cluster:
LDR R1, [SP,#4]
ADD R3, #1
CMP R1, R3
BEQ fin_inicio_clusters
SUB R4, #4
STR R3, [SP, R4]

LDR R0, [SP]
LDR R1, [SP,#4]
MOV R5, #4
SUB R0, R2
MUL R5, R1
ADD R5, #12
MUL R5, R0
SUB R5, #4
LDR R0, [SP, R5]
ADD R0, #1
STR R0, [SP, R5]

B loop_ultimo_cluster

fin_inicio_clusters:

MOV R2, #0 

loop_nuevos_centroides:
LDR R1, [SP]
CMP R2, R1
BEQ fnc

SUB SP, #12

MOV R1, #0
STR R1, [SP] 
STR R1, [SP,#4] 
STR R1, [SP,#8] 

PUSH {R2}
ADD SP, #16
MOV R0, R2
LDR R1, [SP]
LDR R2, [SP, #4]
BL func_offset_cluster
SUB SP, #16
POP {R2}

SUB R0, #8

MOV R1, #0 
ADD SP, #12
LDR R3, [SP, R0] 
SUB SP, #12
SUB R0, #4 

loop_suma_pares:
CMP R1, R3
BEQ sacar_promedio

PUSH {R0, R1, R2, R3}
ADD SP, #28
LDR R0, [SP, R0]
LDR R1, [SP]
LDR R2, [SP, #4]
BL func_offset_par
SUB SP, #12

LDR R1, [SP, #4] 
ADD SP, #12
LDR R2, [SP, R0]
SUB SP, #12
ADD R1, R2
STR R1, [SP, #4]
SUB R0, #4
LDR R1, [SP]     
ADD SP, #12
LDR R2, [SP, R0]
SUB SP, #12
ADD R1, R2
STR R1, [SP]
SUB SP, #16
POP {R0, R1, R2, R3}

ADD R1, #1
SUB R0, #4 
B loop_suma_pares

sacar_promedio:
vldr s0, [SP, #4] 
vmov s1, R3
vdiv.f32 s0, s0, s1
vstr s0, [SP, #4]
vldr s0, [SP] 
vdiv.f32 s0, s0, s1
vstr s0, [SP]

PUSH {R2}
ADD SP, #16
MOV R0, R2
LDR R1, [SP]
LDR R2, [SP, #4]
BL func_offset_cluster
SUB SP, #12


LDR R1, [SP, #4]
ADD SP, #12
LDR R2, [SP, R0]
BL func_cambio_centroide
STR R1, [SP, R0]
SUB SP, #12
SUB R0, #4
LDR R1, [SP]
ADD SP, #12
LDR R2, [SP, R0]
BL func_cambio_centroide
STR R1, [SP, R0]
SUB SP, #16
POP {R2}
ADD SP, #12
ADD R2, #1
B loop_nuevos_centroides


fnc:
SUB SP, #4
LDR R0, [SP]
ADD SP, #4
CMP R0, #0
BNE resultados

MOV R0, #0 

reiniciar_array_indices:
LDR R1, [SP]
CMP R0, R1
BEQ salir_reinicio

LDR R1, [SP]
LDR R2, [SP, #4]

PUSH {R0}
BL func_offset_cluster
SUB R0, #8 
MOV R1, #0
ADD SP, #4
STR R1, [SP, R0]
SUB SP, #4
POP {R0}

ADD R0, #1
B reiniciar_array_indices

salir_reinicio:

MOV R0, #0 

loop_distancia_puntos:
LDR R1, [SP]
LDR R2, [SP, #4]
CMP R0, R2
BEQ fin_inicio_clusters

MOV R3, #4
MUL R3, R1
SUB SP, R3
MOV R5, #0 

PUSH {R0, R1, R2, R3}
BL func_offset_par
MOV R4, R0
POP {R0, R1, R2, R3}
ADD SP, R3
vs0a:
LDR R6, [SP, R4] 
vmov s0, R6 
vcvt.f32.s32 s0, s0
vs0d:
SUB R4, #4
vs1a:
LDR R6, [SP, R4] 
vmov s1, R6
vcvt.f32.s32 s1, s1
vs1d:
SUB SP, R3

loop_dist_clusters:
CMP R5, R1
BEQ salir_loop_dist

PUSH {R0, R1, R2, R3}
MOV R0, R5
vp1:
BL func_offset_cluster
vs1:
MOV R4, R0
POP {R0, R1, R2, R3}
ADD SP, R3
LDR R6, [SP, R4] 
vmov s2, R6
SUB R4, #4
LDR R6, [SP, R4] 
vmov s3, R6
SUB SP, R3
vfas:

vsub.f32 s2, s0
vabs.f32 s2, s2 
vsub.f32 s3, s1
vabs.f32 s3, s3 
vadd.f32 s2, s3 

MOV R4, #4
MUL R4, R5
SUB R4, R3, R4
SUB R4, #4
vmov R6, s2
STR R6, [SP, R4]
ADD R5, #1
B loop_dist_clusters

salir_loop_dist:

PUSH {R0, R1, R2, R3}
ADD R0, R3, #16

BL func_indice_minimo
vrim:
MOV R4, R0
POP {R0, R1, R2, R3}

ADD SP, R3

PUSH {R0, R1, R2}
MOV R0, R4
BL func_offset_cluster
ADD SP, #12
SUB R0, #8 
LDR R1, [SP, R0]
ADD R1, #1
STR R1, [SP, R0]
MOV R2, #4
MUL R2, R1
SUB R1, R0, R2
SUB SP, #12
POP {R0}
ADD SP, #8
STR R0, [SP, R1]
SUB SP, #8
POP {R1, R2}

ADD R0, #1
B loop_distancia_puntos

resultados:
LDR R0, =salto_linea
BL printf
LDR R0, =encabezado_cluster
BL printf

MOV R6, #0

loop_imprimir_res:

LDR R1, [SP]
CMP R6, R1
BEQ salir

MOV R0, R6
LDR R2, [SP, #4]
antes_entrar:
BL func_offset_cluster
despues_entrar:
LDR R1, [SP, R0]
vmov s0, R1
vcvt.u32.f32 s1, s0
vmov.f32 R1, s1 
vcvt.f32.u32 s1, s1
vsub.f32 s2, s0, s1
MOV R2, #1000
vmov s3, R2
vcvt.f32.u32 s3, s3
vmul.f32 s2, s3
vcvt.u32.f32 s2, s2
vmov.f32 R2, s2 
SUB R0, #4
LDR R3, [SP, R0]
vmov s0, R3
vcvt.u32.f32 s1, s0
vmov.f32 R3, s1 
vcvt.f32.u32 s1, s1
vsub.f32 s2, s0, s1

MOV R4, #1000
vmov s3, R4
vcvt.f32.u32 s3, s3
vmul.f32 s2, s3
vcvt.u32.f32 s2, s2
vmov.f32 R4, s2 

SUB R0, #4
LDR R5, [SP, R0] 

LDR R0, =cluster_format
PUSH {R4, R5, R6}
BL printf
POP {R4, R5, R6}
ADD R6, #1
B loop_imprimir_res

salir:
MOV R7, #1
SVC 0

func_cambio_centroide:
CMP R2, R1
BNE f_no_cambio
SUB SP, #4
LDR R2, [SP]
ADD R2, #1
STR R2, [SP]
ADD SP, #4
f_no_cambio:
MOV pc,lr

func_indice_minimo:
SUB R1, #1
MOV R2, #0 
SUB R0, #4
MOV R3, #0
LDR R6, [SP, R0]
vmov s0, R6

loop_func_indice:
CMP R2, R1
BEQ salir_func_minimo
ADD R2, #1
SUB R0, #4
LDR R6, [SP, R0]
vmov s1, R6
vcmp.f32 s1, s0
vmrs APSR_nzcv, FPSCR
bgt cont_bucle_indice
MOV R3, R2
vmov s0, s1
cont_bucle_indice:
B loop_func_indice

salir_func_minimo:
MOV R0, R3
MOV pc, lr

func_offset_par:
MOV R3, #4
MOV R4, #8
MUL R3, R2
ADD R3, #12
MUL R3, R1
SUB R2, R0
MUL R2, R4
ADD R0, R3, R2
ADD R0, #4
MOV pc, lr

func_offset_cluster:
MOV R3, #4
MUL R3, R2
ADD R3, #12
SUB R1, R0
MUL R1, R3
ADD R0, R1, #4
MOV pc, lr

.data

formato_nombre: .asciz "%s"
txt_escribir: .asciz "Nombre del archivo de prueba: "
archivo_entrada: .asciz "             "

salto_linea: .asciz "\n"
encabezado_cluster: .asciz "Clusters: \n"
cluster_format: .asciz "Cluster: (%d.%d, %d.%d) - Veces Limpiado: %d\n"
buffer_ascii: .asciz " "
