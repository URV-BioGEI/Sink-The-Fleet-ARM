@;=========== Fichero fuente principal de la práctica de los barcos  ===========
@;== 	define las variables globales principales del juego (matriz_barcos,	  ==
@;== 	matriz_disparos, ...), la rutina principal() y sus rutinas auxiliares ==
@;== 	programador1: aleix.marine@estudiants.urv.cat						  ==
@;== 	programador2: daniel.diazf@estudiants.urv.cat						  ==


@;-- símbolos habituales ---
NUM_PARTIDAS = 150


@;--- .bss. non-initialized data ---

.bss
	nd8: .space 4					@; promedio de disparos para tableros de 8x8
	nd9: .space 4					@; de 9x9
	nd10: .space 4					@; de 10x10
	matriz_barcos:	 .space 100		@; códigos de los barcos a hundir
	matriz_disparos: .space 100		@; códigos de los disparos realizados
	quo: .space 4					@; var quo pel quocient de la divisio
	mod: .space 4					@; var del residu mòdul


@;-- .text. código de las rutinas ---
.text	
		.align 2
		.arm


@; principal():
@;	rutina principal del programa de los barcos; realiza n partidas para cada
@;	uno de los 3 tamaños de tablero establecidos (8x8, 9x9 y 10x10), calculando
@;	el promedio del número de disparos necesario para hundir toda la flota,
@;	que se inicializará en posiciones aleatorias en cada partida; los valores
@;	promedio se deben escribir en las variables globales 'nd8', 'nd9' y 'nd10',
@;	respectivamente 
		.global principal
principal:
		push {lr}
		mov r0, #8					@;partides de 8x8
		ldr r1, =matriz_barcos		
		ldr r2, =matriz_disparos
		ldr r3, =nd8
		bl realizar_partidas
		mov r0, #9					@;partides de 9x9
		ldr r3, =nd9
		bl realizar_partidas
		mov r0, #10					@;partides de 10x10
		ldr r3, =nd10
		bl realizar_partidas
		pop {pc}



@; realizar_partidas(int dim, char tablero_barcos[], 
@;								char tablero_disparos[], char *var_promedio):
@;	rutina para realizar un cierto número de partidas (NUM_PARTIDAS) de la
@;	batalla de barcos, sobre un tablero de barcos y un tablero de disparos
@;	pasados por parámetro, junto con la dimensión de dichos tableros, de
@;	modo que se calcula el promedio de disparos de cada partida necesarios para
@;	hundir todos los barcos; dicho promedio se almacena en la posición de
@;	memoria referenciada por el parámetro 'var_promedio'.
@;	Parámetros:
@;		R0: dim; tamaño de los tableros (dimxdim)
@; 		R1: tablero_barcos[]; dirección base del tablero de barcos
@; 		R2: tablero_disparos[]; dirección base del tablero de disparos
@;		R3: var_promedio (dir); dirección de la variable que albergará el pro-
@;								medio de disparos.
realizar_partidas:
		push {r0-r9, lr}
		mov r4, #0					@;inicialitza comptador bucle
		mov r5, #0					@;inicialitza comptador total trets
		mov r6, r0					@;copiem el contingut de r0 (dim) temporalment
		mov r7, r1
		mov r8, r2					@;movem temporalment el tauler de trets
		mov r9, r3					@;carrguem @var_promedio a r9
		.partida:					@;inici del bucle
		mov r0, r6					@;retornem a r0 el valor de dim
		mov r1, r7
		bl B_inicializa_barcos		@;inicialitza taulell vaixells
		mov r0, r6					@;restaurem r0 la dimensio
		bl B_inicializa_disparos	@;inicialitza el taulell de trets a ?
		mov r1, r2					@;carreguem el taulell de trets a r2 (parametre de jugar)
		bl jugar					@;crida a jugar, en aquesta rutina r0 ara es el nombre de trets!!! 
		add r5, r0					@;carreguem a r5 el nombre de trets, sumant pels anteriors
		add r4, #1					@;increment comptador r4
		cmp r4, #NUM_PARTIDAS		@;compara...
		blt .partida				@;salta si r4 es mes petit que NUM_PARTIDA
		mov r0, r5					@;carrega a r0 el nombre de trets total
		mov r1, r4					@;carrega a r1 el nombre de partides, ho faig sense la constant per a no accedir a memoria
		ldr r2, =quo				@;carreguem direcció de memoria del quocient
		ldr r3, =mod				@;carreguem direcció de memoria del modul
		bl div_mod					@;fem la divisio
		ldr r0, [r2]				@;carreguem el valor de memoria al que apunta r2 en el registre temporal r0
		str r0, [r9]				@;carreguem a la posicio de memoria a la que apunta r9, es a dir, la var. ndX, el valor de r0, quocient
		pop {r0-r9, pc}

B_inicializa_disparos:
@; r0 rep dim
@; r2 @taulell de trets
		push {r1-r4, lr}
		mov r1, #0							@;comptador
		mul r4, r0, r0						@;mutipliquem dim per dim per obtenir el nombre de caselles per recorrer
		mov r3, #63							@;registre temporal que em carrega els interrogants
		.bucleinicitrets:
		strb r3, [r2]						@;guardem interrogants en la posicio a la que apunta r2 (taulell de trets)
		add r2, #1						    @;incrementem la posicio
		add r1, #1							@;incrementem comptador
		cmp r1, r4							@;comparem amb les caselles totals
		bne .bucleinicitrets				@;salta mentre sigui mes petit i quan sigui dim*dim surt de la funcio
		pop {r1-r4, pc}
.end
