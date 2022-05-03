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

.macro WALK(%l, %c)
	REFRESH(s7,0)
	FRAME(1)
	print_sprite0(%l, %c, andar_1)
	li a0, 300
	SYSCALL(SLEEP)
	REFRESH(s7,1)
	FRAME(0)
.end_macro