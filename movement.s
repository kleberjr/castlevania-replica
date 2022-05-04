# ASCII
.eqv um 49
.eqv a 97
.eqv c 99
.eqv d 100
.eqv e 101
.eqv g 103
.eqv q 113
.eqv w 119
.eqv x 120
.eqv z 122
.eqv s 115
.eqv W 87
.eqv E 69
.eqv A 65
.eqv C 67
.eqv Q 81
.eqv Z 90
.eqv X 88
.eqv D 68

# ------------------------- AÇÕES ----------------------------- #

.macro walk(%l, %c)
	REFRESH(0)
	FRAME(1)
	PRINT_SPRITE_0(%l, %c, walk_1)
	li a0, 300
	SYSCALL(SLEEP)
	REFRESH(1)
	FRAME(0)
.end_macro

# Executa o movimento de acordo com a tecla pressionada.
.macro ACTION(%char, %prev.column, %prev.line)
	.data
		.include "./sprites/richard/stand.data"
		.include "./sprites/richard/walk_1.data"
		.include "./sprites/richard/walk_2.data"
		.include "./sprites/richard/walk_3.data"
		.include "./sprites/richard/walk_4.data"
		.include "./sprites/richard/walk_5.data"
		.include "./sprites/richard/walk_6.data"
		.include "./sprites/richard/walk_7.data"
		.include "./sprites/richard/walk_8.data"
		.include "./sprites/richard/run_1.data"
		.include "./sprites/richard/run_2.data"
		.include "./sprites/richard/run_3.data"

	.text
		li t0 a
		beq %char t0 J_ACAO_a
		li t0 q
		beq %char t0 J_ACAO_q
		li t0 w
		beq %char t0 J_ACAO_w
		li t0 e
		beq %char t0 J_ACAO_e
		li t0 d
		beq %char t0 J_ACAO_d	
		j EXIT

		J_ACAO_a: j ACAO.a
		J_ACAO_q: j ACAO.q
		J_ACAO_w: j ACAO.w	
		J_ACAO_e: j ACAO.e
		J_ACAO_d: j ACAO.d

	
			
ACAO.a:	# ANDAR ESQUERDA ------------------------------------------------- #
	
	li t4, -4
	get_next_column(%prev.column, t4)
	slti t5, t5, 0		# s1 = (pixel < 0) ? 1 : 0
	bne t5, zero, J_EXIT_a
		
	REFRESH(0)
	addi %prev.column %prev.column -4
	PRINT_SPRITE_0(%prev.column, %prev.line, walk_1)
	
	li t4, -4
	get_next_column(%prev.column, t4)
	slti t5, t5, 0		# s1 = (pixel < 0) ? 1 : 0
	bne t5, zero, J_EXIT_a
	
	REFRESH(0)
	FRAME(0)
	addi %prev.column %prev.column -4
	PRINT_SPRITE_0(%prev.column, %prev.line, walk_2)
	
	li t4, -4
	get_next_column(%prev.column, t4)
	slti t5, t5, 0		# s1 = (pixel < 0) ? 1 : 0
	bne t5, zero, J_EXIT_a
	
	REFRESH(0)
	FRAME(0)
	addi %prev.column %prev.column -4
	PRINT_SPRITE_0(%prev.column, %prev.line, walk_3)
	
	li t4, -4
	get_next_column(%prev.column, t4)
	mv t6, t5
	slti t5, t5, 0		# s1 = (pixel < 0) ? 1 : 0
	bne t5, zero, J_EXIT_a
	
	REFRESH(0)
	FRAME(0)
	addi %prev.column %prev.column -4
	PRINT_SPRITE_0(%prev.column, %prev.line, walk_2)
	REFRESH(0)
	FRAME(0)
	
	# Calcula o primeiro pixel (superior esquerdo) ------------- #
	get_first_pixel(%prev.column, %prev.line)
	
	# Calcula o último pixel (inferior direito) ---------------- #
	get_left_last_pixel(t5)
	
	check_colision(t5)

J_EXIT_a:
		j EXIT
	
ACAO.d: # ANDAR DIREITA --------------------------------------------------- #
	REFRESH(0)
	addi %prev.column %prev.column, 4
	PRINT_SPRITE_0(%prev.column, %prev.line, walk_1)
	
	REFRESH(0)
	addi %prev.column %prev.column 4
	PRINT_SPRITE_0(%prev.column, %prev.line, walk_3)

	REFRESH(0)
	addi %prev.column %prev.column 4
	PRINT_SPRITE_0(%prev.column, %prev.line, walk_4)
	
	REFRESH(0)
	addi %prev.column %prev.column 4
	PRINT_SPRITE_0(%prev.column, %prev.line, walk_5)
	
	REFRESH(0)
	addi %prev.column %prev.column 4
	PRINT_SPRITE_0(%prev.column, %prev.line, walk_7)	
	
	REFRESH(0)
	addi %prev.column %prev.column 4
	PRINT_SPRITE_0(%prev.column, %prev.line, walk_8)
	
	check_win(%prev.column)	
	
	# Calcula o primeiro pixel (superior esquerdo) ------------- #
	get_first_pixel(%prev.column, %prev.line)
	
	# Calcula o último pixel (inferior direito) ---------------- #
	get_right_last_pixel(t5)
	
	check_colision(t5)
	
	j EXIT	
	
ACAO.w: # PULAR ------------------------------------------------------------ #
	REFRESH(0)
	PRINT_SPRITE_0(%prev.column, %prev.line, run_1)
	li a0, 125
	SYSCALL(SLEEP)
	REFRESH(0)

	addi %prev.line, %prev.line, -30
	PRINT_SPRITE_0(%prev.column, %prev.line, run_2)
	li a0, 77
	li a1, 500
	li a2, 0
	li a3, 100
	li a7, 31
	ecall
	li a0, 175
	SYSCALL(SLEEP)
	REFRESH(0)

	PRINT_SPRITE_0(%prev.column, %prev.line, run_3)
	li a0, 50
	li a1, 1000
	li a2, 127
	li a3, 100
	li a7, 31
	ecall
	
	REFRESH(0)
	PRINT_SPRITE_0(%prev.column, %prev.line, run_2)
	li a0, 150
	SYSCALL(SLEEP)
	addi %prev.line, %prev.line, 30
	
	# Calcula o primeiro pixel (superior esquerdo) ------------- #
	get_first_pixel(%prev.column, %prev.line)
	
	# Calcula o último pixel (inferior direito) ---------------- #
	get_right_last_pixel(t5)
	
	check_colision(t5)
	
	j EXIT
	
ACAO.q: # PULAR ESQUERDA ---------------------------------------------- #
	
	REFRESH(0)
	PRINT_SPRITE_0(%prev.column, %prev.line, run_1)
	
	li a0, 125
	SYSCALL(SLEEP)
	
	li t4, -28
	get_next_column(%prev.column, t4)
	slti t5, t5, 0		# s1 = (pixel < 0) ? 1 : 0
	bne t5, zero, J_EXIT_q
	
	REFRESH(0)
	addi %prev.column, %prev.column, -28
	addi %prev.line, %prev.line, -30
	PRINT_SPRITE_0(%prev.column, %prev.line, run_2)
	
	li a0, 77
	li a1, 500
	li a2, 0
	li a3, 100
	li a7, 31
	ecall
	
	li a0, 175
	SYSCALL(SLEEP)
	
	li t4, -32
	get_next_column(%prev.column, t4)
	slti t5, t5, 0		# s1 = (pixel < 0) ? 1 : 0
	bne t5, zero, J_EXIT_q
	
	REFRESH(0)
	addi %prev.column, %prev.column, -32
	PRINT_SPRITE_0(%prev.column, %prev.line, run_3)
	
	li a0, 50
	li a1, 1000
	li a2, 127
	li a3, 100
	li a7, 31
	ecall

	REFRESH(0)
	PRINT_SPRITE_0(%prev.column, %prev.line, run_2)
	
	li a0, 150
	SYSCALL(SLEEP)
	
	addi %prev.line, %prev.line, 30
	
	
J_EXIT_q:	
	li %prev.line, 0x0000009C

	# Calcula o primeiro pixel (superior esquerdo) ------------- #
	get_first_pixel(%prev.column, %prev.line)
	
	# Calcula o último pixel (inferior direito) ---------------- #
	get_right_last_pixel(t5)
	
	check_colision(t5)

	j EXIT

ACAO.e: # PULAR DIREITA ------------------------------------------------------ #
	
	REFRESH(0)
	PRINT_SPRITE_0(%prev.column, %prev.line, run_1)
	
	li a0, 125
	SYSCALL(SLEEP)
	
	check_win(%prev.column)
	
	REFRESH(0)
	addi %prev.column, %prev.column, 36
	addi %prev.line, %prev.line, -30
	PRINT_SPRITE_0(%prev.column, %prev.line, run_2)
	
	li a0, 77
	li a1, 500
	li a2, 0
	li a3, 100
	li a7, 31
	ecall
	
	li a0, 175
	SYSCALL(SLEEP)
	
	check_win(%prev.column)
	
	REFRESH(0)
	addi %prev.column, %prev.column, 36
	PRINT_SPRITE_0(%prev.column, %prev.line, run_3)
	
	li a0, 50
	li a1, 1000
	li a2, 127
	li a3, 100
	li a7, 31
	ecall
	
	check_win(%prev.column)
	
	REFRESH(0)
	PRINT_SPRITE_0(%prev.column, %prev.line, run_2)
	
	li a0, 150
	SYSCALL(SLEEP)
	addi %prev.line, %prev.line, 30
	
	check_win(%prev.column)	
	
	# Calcula o primeiro pixel (superior esquerdo) ------------- #
	get_first_pixel(%prev.column, %prev.line)
	
	# Calcula o último pixel (inferior direito) ---------------- #
	get_right_last_pixel(t5)
	
	check_colision(t5)
	
	j EXIT


EXIT:
	REFRESH(0)
	PRINT_SPRITE_0(%prev.column, %prev.line, stand)
	REFRESH(1)
	FRAME(0)

.end_macro

