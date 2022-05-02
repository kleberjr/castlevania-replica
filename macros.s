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