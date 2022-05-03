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
# 	Definição: Chama a syscall de acordo com a operação.		#
# ------------------------------------------------------------- #
#	Argumentos:													#
#		Número da operação da syscall							#
# ------------------------------------------------------------- #
#	Retorno:													#
#		Retorna de acordo com a syscall							#
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
#		Chama a syscall											#
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




# PRINT FULL IMAGE ============================================ #
# ------------------------------------------------------------- #
# 	Definição: Printa uma imagem inteira no display.			#
# ------------------------------------------------------------- #
#	Argumentos:													#
#		String com o path do arquivo							#
# ------------------------------------------------------------- #
#	Retorno:													#
#		Chama a syscall											#
# ------------------------------------------------------------- #
#	Registradores modificados:									#
#		a0, a1, a2, t0											#
# ------------------------------------------------------------- #

.macro PRINT_FULL_IMG(%file_name)
	.data
		FILE:	.string %file_name

	.text
		# Abre o arquivo --------------------------------------------------------- #
		la a0, FILE				# Passa a label com o nome do arquivo a ser aberto.
		li a1, 0				# Indica a leitura de um arquivo.
		li a2, 0				# Indica um arquivo binário.
		SYSCALL(OPEN_FILE)		# Chama a syscall e a0 recebe o descritor do arquivo.
	
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



.macro PRINT_MENU()
	PRINT_FULL_IMG("./sprites/background/menu.bin")
.end_macro




.macro PRINT_ENTRANCE_1()
	PRINT_FULL_IMG("./sprites/background/bg-entrance.bin")
.end_macro	




.macro PRINT_ENTRANCE_2()
	PRINT_FULL_IMG("./sprites/background/bg-entrance-2.bin")
.end_macro



# PRINT_SPRITE ----------------------------------------------------------------------------------------------------- #
# Printa uma sprite na posição desejada.
.macro PRINT_SPRITE_0(%coluna, %linha, %file_adress)
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




.macro REFRESH(%alive, %frame)
.text
	li t0, %frame
	beqz t0, FRAME0
	print_full_img1("cenario_1.bin")
	beqz %alive DEAD
	#li t5 colunaI
	#li t6 linhaI
	#print_sprite1(t5, t6, invisivel)
	#addi t5 t5 -16
	#print_sprite1(t5, t6, invisivel)
	j DEAD
	
FRAME0:	print_full_img0("cenario_1.bin")
	beqz %alive DEAD
	#print_sprite0(t5, t6, invisivel)
DEAD:
.end_macro