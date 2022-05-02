# ============================= INLCUDES =============================== # 
.include "macros.s"
.include "MACROSv21.s"
# ====================================================================== #

.data

.text
	PRINT_FULL_IMG("./sprites/background/background.bin")
	#SYSCALL(EXIT1)
	li a7, 10
	ecall
	
.include "SYSTEMv21.s"