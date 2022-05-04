# Boolean
.eqv TRUE 1
.eqv FALSE 0

# Ecall Codes
.eqv PRINT_INT 1
.eqv PRINT_FLOAT 2
.eqv PRINT_STRING 4
.eqv PRINT_CHAR 11
.eqv EXIT1 10
.eqv EXIT2 93
.eqv OPEN_FILE 1024
.eqv READ_FILE 63
.eqv CLOSE_FILE 57
.eqv SLEEP 32
.eqv TIME 30
.eqv MIDI 33


# Keybord MMIO
.eqv MMIO_BUFFER 0xff200004 	# Data (Endereço do Buffer, onde o valor ASCII da tecla pressionada está)
.eqv MMIO_CTRL 0xff200000 		# Control (valor Booleano, indica se houve tecla pressionada)
.eqv FRAME_SELECT 0xff200604


# SYSCALL ===================================================== #
# ------------------------------------------------------------- #
# 	Definição: Chama a SYSCALL de acordo com a operação.		#
# ------------------------------------------------------------- #
#	Argumentos:													#
#		Número da operação da SYSCALL							#
# ------------------------------------------------------------- #
#	Retorno:													#
#		Retorna de acordo com a SYSCALL							#
# ------------------------------------------------------------- #

.macro SYSCALL(%operation)
	li a7, %operation
	ecall
.end_macro

# ============================================================= #




# FRAME ======================================================= #
# ------------------------------------------------------------- #
# 	Definição: Seleciona o frame do display						#
# ------------------------------------------------------------- #
#	Argumentos:													#
#		Inteiro indicando o frame								#
# ------------------------------------------------------------- #
#	Retorno:													#
#		Chama a SYSCALL											#
# ------------------------------------------------------------- #
#	Registradores modificados:									#
#		t0, t1													#
# ------------------------------------------------------------- #

.macro FRAME(%int)
	li t0, %int
	li t1, FRAME_SELECT
	sw t0, 0(t1)
.end_macro

# ============================================================= #




# PRINT FULL IMAGE 0 ========================================== #
# ------------------------------------------------------------- #
# 	Definição: Printa uma imagem inteira no display 			#
#	utilizando o frame 0.										#
# ------------------------------------------------------------- #
#	Argumentos:													#
#		String com o path do arquivo							#
# ------------------------------------------------------------- #
#	Retorno:													#
#		Chama a SYSCALL											#
# ------------------------------------------------------------- #
#	Registradores modificados:									#
#		a0, a1, a2, t0											#
# ------------------------------------------------------------- #

.macro PRINT_FULL_IMG_0(%file_name)
	.data
		FILE:	.string %file_name

	.text
		# Abre o arquivo --------------------------------------------------------- #
		la a0, FILE				# Passa a label com o nome do arquivo a ser aberto.
		li a1, 0				# Indica a leitura de um arquivo.
		li a2, 0				# Indica um arquivo binário.
		SYSCALL(OPEN_FILE)		# Chama a SYSCALL e a0 recebe o descritor do arquivo.
	
		mv t0, a0				# Salva o descritor em t0.

		# Lê o arquivos para a memoria VGA --------------------------------------- #
		li a1, 0xFF000000		# Endereço onde os bytes lidos do arquivo serão escritos.
		li a2, 76800			# Quantidade de bytes a serem lidos.
		SYSCALL(READ_FILE)		# Lê o arquivo e retorna em a0 o comprimento.
	
		# Fecha o arquivo -------------------------------------------------------- #
		mv a0, t0				# a0 recebe novamente o descritor.
		SYSCALL(CLOSE_FILE)		# Fecha o arquivo.
.end_macro

# ============================================================= #




# PRINT FULL IMAGE 1 ========================================== #
# ------------------------------------------------------------- #
# 	Definição: Printa uma imagem inteira no display 			#
#	utilizando o frame 0.										#
# ------------------------------------------------------------- #
#	Argumentos:													#
#		String com o path do arquivo							#
# ------------------------------------------------------------- #
#	Retorno:													#
#		Chama a SYSCALL											#
# ------------------------------------------------------------- #
#	Registradores modificados:									#
#		a0, a1, a2, t0											#
# ------------------------------------------------------------- #
.macro PRINT_FULL_IMG_1(%file_name)
	.data
		FILE:	.string %file_name

	.text
		# Abre o arquivo --------------------------------------------------------- #
		la a0, FILE			# Passa a label com o nome do arquivo a ser aberto.
		li a1,0				# Indica a leitura de um arquivo.
		li a2,0				# Indica um arquivo binário.
		SYSCALL(OPEN_FILE)	# Chama a SYSCALL e a0 recebe o descritor do arquivo.
	
		mv t0, a0			# Salva o descritor em t0.

		# Lê o arquivos para a memoria VGA --------------------------------------- #
		li a1, 0xFF100000	# Endereço onde os bytes lidos do arquivo serão escritos.
		li a2, 76800		# Quantidade de bytes a serem lidos.
		SYSCALL(READ_FILE)	# Lê o arquivo e retorna em a0 o comprimento.
	
		# Fecha o arquivo -------------------------------------------------------- #
		mv a0, t0			# a0 recebe novamente o descritor.
		SYSCALL(CLOSE_FILE)	# Fecha o arquivo.
.end_macro



.macro PRINT_MENU()
	PRINT_FULL_IMG_0("./sprites/background/menu.bin")
.end_macro

.macro PRINT_ENTRANCE_1()
	PRINT_FULL_IMG_0("./sprites/background/bg-entrance.bin")
.end_macro	

.macro PRINT_ENTRANCE_2()
	PRINT_FULL_IMG_0("./sprites/background/bg-entrance-2.bin")
.end_macro



# PRINT_SPRITE ----------------------------------------------------------------------------------------------------- #
# Printa uma sprite na posição desejada.
.macro PRINT_SPRITE_0(%coluna, %linha, %file_adress)
.data

.text
	la a0, %file_adress		# a0 endereço da imagem
	lw t0, 0(a0)			# numero de colunas
	lw t1, 4(a0)			# numero de linhas
	mul a2, t0, t1			# tamanho imagem
	
	li t1, 0x140
	mul t1, t1, %linha		# multiplica 0x140 por linha
	add t1, t1, %coluna		# soma coluna ao valor de cima
	li a1, 0xff000000
	add a1, t1, a1			# soma o valor de cima ao endereço da tela, endereço onde será printado sprite
	li t1, 0				# contador 1
	li t2, 0				# contador 2
	addi a0, a0, 8
LOOP:
	beq t1, a2, DONE		# se o contador 1 for igual ao tamanho da img vai para DONE
	lw t3, 0(a0)			# carrega a word da imagem
	sw t3, 0(a1)			# coloca word no endereço calculado acima
	addi a0, a0, 4
	addi a1, a1, 4
	addi t1, t1, 4
	addi t2, t2, 4
	blt t2, t0, LOOP		# verifica se t2 esta do tamanho da largura da img
	li t2, 0x140			# 0x140 equivale a uma linha no bitmap display
	sub t2, t2, t0			# subtrai 0x140-colunas para alinhamento
	add a1, a1, t2			# soma t2 ao endereço do bitmap
	li t2, 0				# zera o contador2
	j LOOP
DONE:
.end_macro



# PRINT_SPRITE ----------------------------------------------------------------------------------------------------- #
# Printa uma sprite na posição desejada.
.macro PRINT_SPRITE_1(%coluna, %linha, %file_adress)
.data

.text
	la a0 %file_adress		# a0 endereço da imagem
	lw t0 0(a0)				# numero de colunas
	mv a5 t0
	lw t1 4(a0)				# numero de linhas
	mul a2 t0 t1			# tamanho imagem
	li t1 0x140
	mul t1 t1 %linha		# multiplica 0x140 por linha
	add t1 t1 %coluna		# soma coluna ao valor de cima
	li a1 0xff100000
	add a1 t1 a1			# soma o valor de cima ao endereço da tela, endereço onde será printado sprite
	li t1 0					# contador 1
	li t2 0					# contador 2
	addi a0 a0 8
LOOP:
	beq t1 a2 DONE			# se o contador 1 for igual ao tamanho da img vai para DONE
	lw t3 0(a0)				# carrega a word da imagem
	sw t3 0(a1)				# coloca word no endereço calculado acima
	addi a0 a0 4
	addi a1 a1 4
	addi t1 t1 4
	addi t2 t2 4
	blt t2 t0 LOOP			# verifica se t2 esta do tamanho da largura da img
	li t2 0x140				# 0x140 equivale a uma linha no bitmap display
	sub t2 t2 t0			# subtrai 0x140-colunas para alinhamento
	add a1 a1 t2			# soma t2 ao endereço do bitmap
	li t2 0					# zera o contador2
	j LOOP

DONE:
.end_macro



.macro REFRESH(%alive, %frame)
	.text
		li t0, %frame
		beqz t0, FRAME0
		PRINT_FULL_IMG_1("./sprites/background/bg-life-100.bin")
		beqz %alive DEAD
		
		# li t5 colunaI
		# li t6 linhaI
		# print_sprite1(t5, t6, invisivel)
		# addi t5 t5 -16
		# print_sprite1(t5, t6, invisivel)
		
		j DEAD
	
		FRAME0:	PRINT_FULL_IMG_0("./sprites/background/bg-life-100.bin")
				beqz %alive DEAD
				# print_sprite0(t5, t6, invisivel)
		DEAD:
.end_macro



.macro DEFEAT()
.data
	# Tamanho:76
	NOTAS: .word 72,667,72,166,67,166,74,166,76,1167,76,166,77,166,79,833,81,333,79,166,77,333,76,333,74,333,72,166,74,166,76,333,76,166,77,166,79,2334,72,166,74,166,76,166,77,166,76,1667,72,667,72,166,67,166,72,166,79,1167,79,166,81,166,83,833,84,333,83,166,81,333,79,333,77,333,74,166,72,166,76,333,76,166,77,166,79,2334,84,166,86,166,88,2001,89,2334,88,166,86,166,84,2001,83,166,84,166,86,166,83,166,84,333,79,2668,74,166,76,166,77,333,76,1667,79,2334,81,166,83,166,84,2001,86,166,88,166,89,166,86,166,87,333,84,1667,77,166,79,166,83,166,79,166,84,333,79,2334
.text
	FRAME(0)
	PRINT_FULL_IMG_0("./sprites/background/bg-death.bin")
	
	li s1, 76			# define o endereço do número de notas e le o numero de notas
	la s0, NOTAS		# define o endereço das notas
	li t0, 0			# zera o contador de notas
	li a2, 45			# define o instrumento
	li a3, 127			# define o volume

LOOP:	beq t0, s1, EXIT
		PRINT_FULL_IMG_1("./sprites/background/bg-death.bin")
		lw a0, 0(s0)
		lw a1, 4(s0)
		SYSCALL(MIDI)
		addi s0, s0, 8
		addi t0, t0, 1
		j LOOP
		
EXIT:
.end_macro


.macro DECREASE_LIFE()
	addi s8, s8, -50
	bne s8, zero, EXIT
	DEFEAT()
	
EXIT:
.end_macro


.macro check_colision(%pixel)
.data
	.include "./sprites/background/hitbox.data"
	.eqv RED 7

.text
	la s9, hitbox		# Armazena o endereço da hitbox
	addi s9, s9, 8		# A hitbox só começa no endereço base + 8...
	
	add s9, s9, %pixel	# Salva o endereço do pixel na hitbox
	
	lb t4, 0(s9)		# Pega o pixel	
	
	# mv t6, t4
	
	li t5, RED		
	#slti t4, t4, RED	
	bne t4, t5, EXIT	# Se o pixel for vermelho, então chama a macro de diminuir vida.
	
	DECREASE_LIFE()

EXIT:
.end_macro


# ESPINHOS ------------------------------------------------------------ #
# posição espinhos
.eqv coluna_espinhos1 138 #184-42
.eqv coluna_espinhos2 184

.macro colisao_espinhos(%char_column)
	mv t2 %char_column
#CONDICAO1:
	li t0 coluna_espinhos1
	bge t2 t0 CONDICAO2
	j EXIT
	
CONDICAO2:
	li t0 coluna_espinhos2
	ble t2 t0 COLISAO
	j EXIT
COLISAO:
	addi s7 s7 -1
EXIT:
.end_macro

# BURACO ------------------------------------------------------------ #
# posição buraco
.eqv coluna_buraco1 230 #272-42
.eqv coluna_buraco2 272 

.macro colisao_buraco(%char_column)
	mv t2 %char_column
#CONDICAO1:
	li t0 coluna_buraco1
	bge t2 t0 CONDICAO2
	j EXIT
	
CONDICAO2:
	li t0 coluna_buraco2
	ble t2 t0 COLISAO
	j EXIT
COLISAO:
	addi s7 s7 -1
EXIT:
.end_macro

# CHEGOU NO FINAL DA TELA? ------------------------------------------------------------ #
.macro final_tela(%char_column)
	li t3 280 #248 + 32
	mv t4 %char_column
	bge t4 t3 FINAL
	j EXIT
FINAL:
	li s4 -1
EXIT:
.end_macro
