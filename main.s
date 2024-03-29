# ============================= INLCUDES =============================== # 
.include "macros.s"
.include "MACROSv21.s"
.include "movement.s"
# ====================================================================== #

.data

.text

# MENU --------------------------------------------------------------------------- #
	PRINT_MENU()			# Printa o menu.
	li s0, MMIO_CTRL		# s0 recebe o endere�o onde o bit de controle do teclado est� armazenado.
	sw zero, 0(s0)			# Limpa o bit de controle, evitando que qualquer tecla pressionada antes da execu��o seja interpretada.
	li t2, 0x66				# t2 recebe o valor ASCII de 'f'.

MENU_LOOP:			
	lb t1, 0(s0)			# t1 recebe o bit de controle (1 = teclado quer mandar um dado, 0 = teclado n�o quer mandar um dado).
	beqz t1, MENU_LOOP		# Reinicia o loop caso t1 = 0 (caso o teclado n�o queira mandar nenhum dado).
	li a0, MMIO_BUFFER		# a0 recebe o endere�o onde o valor ASCII da tecla pressionada est� guardado.
	lw a0, 0(a0)			# Instru��o necess�ria para que o dado n�o se perca.
	
	# a0 cont�m o valor ASCII do caractere agora.
	
	beq a0, t2, FIM_MENU	# Caso o caractere seja igual a 'f', sai do menu.
	j MENU_LOOP				# Loop infinito at� que 'f' seja pressionado.
FIM_MENU:


# CENA1 --------------------------------------------------------------------------- #
	PRINT_ENTRANCE_1()		# Printa a cena 1.
	li s0, MMIO_CTRL		# s0 recebe o endere�o onde o bit de controle do teclado est� armazenado.
	sw zero, 0(s0)			# Limpa o bit de controle, evitando que qualquer tecla pressionada antes da execu��o seja interpretada.
	li t2, 0x66				# t2 recebe o valor ASCII de 'f'.

ENTRANCE1_LOOP:			
	lb t1, 0(s0)				# t1 recebe o bit de controle (1 = teclado quer mandar um dado, 0 = teclado n�o quer mandar um dado).
	beqz t1, ENTRANCE1_LOOP		# Reinicia o loop caso t1 = 0 (caso o teclado n�o queira mandar nenhum dado).
	li a0, MMIO_BUFFER			# a0 recebe o endere�o onde o valor ASCII da tecla pressionada est� guardado.
	lw a0, 0(a0)				# Instru��o necess�ria para que o dado n�o se perca.
								# a0 cont�m o valor ASCII do caractere agora.
	beq a0, t2, FIM_ENTRANCE1	# Caso o caractere seja igual a 'f', sai da cena 1.
	j ENTRANCE1_LOOP				# Loop infinito at� que 'f' seja pressionado.
FIM_ENTRANCE1:


# CENA2 --------------------------------------------------------------------------- #
	PRINT_ENTRANCE_2()		# Printa a cena 2.
	li s0, MMIO_CTRL		# s0 recebe o endere�o onde o bit de controle do teclado est� armazenado.
	sw zero, 0(s0)			# Limpa o bit de controle, evitando que qualquer tecla pressionada antes da execu��o seja interpretada.
	li t2, 0x66				# t2 recebe o valor ASCII de 'f'.

ENTRANCE2_LOOP:			
	lb t1, 0(s0)				# t1 recebe o bit de controle (1 = teclado quer mandar um dado, 0 = teclado n�o quer mandar um dado).
	beqz t1, ENTRANCE2_LOOP		# Reinicia o loop caso t1 = 0 (caso o teclado n�o queira mandar nenhum dado).
	li a0, MMIO_BUFFER			# a0 recebe o endere�o onde o valor ASCII da tecla pressionada est� guardado.
	lw a0, 0(a0)				# Instru��o necess�ria para que o dado n�o se perca.
								# a0 cont�m o valor ASCII do caractere agora.
	beq a0, t2, FIM_ENTRANCE2	# Caso o caractere seja igual a 'f', sai do cena 2.
	j ENTRANCE2_LOOP			# Loop infinito at� que 'f' seja pressionado.
FIM_ENTRANCE2:


# JOGO COME�A ---------------------------------------------------------------------------- #
	li s7, 2			# Indica que o jogador est� vivo.
	li s8, 100			# Indica que a vida do jogador est� cheia
	li s10, 0
	li s11, 156

POOL_LOOP:
	lb t1, 0(s0)		# t1 recebe o bit de controle (1 = teclado quer mandar um dado, 0 = teclado n�o quer mandar um dado)

PULEI:	beqz t1, POOL_LOOP		# Reinicia o loop caso t1 = 0 (caso o teclado n�o queira mandar nenhum dado).
		li a0, MMIO_BUFFER		# a0 recebe o endere�o onde o valor ASCII da tecla pressionada est� guardado.
		lw a0, 0(a0)			# Instru��o necess�ria para que o dado n�o se perca.

		# a0 cont�m o valor ASCII do caractere agora.					
		
		ACTION(a0, s10, s11)
		j POOL_LOOP				# Loop infinito do teclado.
	
EXIT:
	SYSCALL(EXIT1)		# Finaliza a execu��o do programa.

.include "SYSTEMv21.s"
