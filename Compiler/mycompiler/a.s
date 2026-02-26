init:
	addi   $sp, $zero, 1024
	addi   $fp, $sp, 0
	stop_service =99

	.text #テキストセグメントの開始
	jal		main # jump to `main`
	nop #(delay slot)
stop: # if syscall return
	j		stop # infinite loop...
	nop #(delay slot)

quicksort:
	addi	$sp, $sp, -8	# Colling convention
	sw		$ra, 0($sp)	# Saving $ra
	sw		$fp, 4($sp)	# Saving $fp
	addi	$fp, $sp, 0
# Declare variable a, offset 8
# Declare variable l, offset 12
# Declare variable r, offset 16
# Declare variable v, offset 24
# Declare variable i, offset 28
# Declare variable j, offset 32
# Declare variable t, offset 36
# Declare variable ii, offset 40
	addi	$sp, $sp, -40	# allocate local variables
# START if_1
	lw		$v0, 16($fp)
	nop
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lw		$v0, 12($fp)
	nop
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	slt		$v0, $v0, $t0
	beq		$v0, $zero, _IF_1
	nop
# START if body
	addi		$t1, 0
	lw		$v0, 16($fp)
	nop
	lui		$t2, 65535
	ori		$t2, $t2, 65535
	mult	$t1, $t2
	mflo	$t1
	add		$t1, $t1, $v0
	lw		$v0, 8($fp)
	nop
	sll		$t1, $t1, 2
	add		$v0, $v0, $t1
	lw		$v0, 0($v0)
	nop
	sw		$v0, -24($fp)
	nop
	lw		$v0, 12($fp)
	nop
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lui		$v0, 0
	ori		$v0, $v0, 1
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sub		$v0, $t0, $v0	# SUB_AST
	sw		$v0, -28($fp)
	nop
	lw		$v0, 16($fp)
	nop
	sw		$v0, -32($fp)
	nop
_FOR_0:
# START for body
_WHILE_0:
	addi		$t1, 0
	lw		$t3, -28($fp)
	nop
	addi	$t3, $t3, 1
	sw		$t3, -28($fp)
	addi	$v0, $t3, 0
	lui		$t2, 65535
	ori		$t2, $t2, 65535
	mult	$t1, $t2
	mflo	$t1
	add		$t1, $t1, $v0
	lw		$v0, 8($fp)
	nop
	sll		$t1, $t1, 2
	add		$v0, $v0, $t1
	lw		$v0, 0($v0)
	nop
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lw		$v0, -24($fp)
	nop
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	slt		$v0, $t0, $v0
	beq		$v0, $zero, _WHILE_END_0
	nop
# START while body
# END while body
	j		_WHILE_0
	nop
_WHILE_END_0:
_WHILE_1:
	addi		$t1, 0
	lw		$t3, -32($fp)
	nop
	addi	$t3, $t3, -1
	sw		$t3, -32($fp)
	addi	$v0, $t3, 0
	lui		$t2, 65535
	ori		$t2, $t2, 65535
	mult	$t1, $t2
	mflo	$t1
	add		$t1, $t1, $v0
	lw		$v0, 8($fp)
	nop
	sll		$t1, $t1, 2
	add		$v0, $v0, $t1
	lw		$v0, 0($v0)
	nop
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lw		$v0, -24($fp)
	nop
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	slt		$v0, $v0, $t0
	beq		$v0, $zero, _WHILE_END_1
	nop
# START while body
# END while body
	j		_WHILE_1
	nop
_WHILE_END_1:
# START if_2
	lw		$v0, -28($fp)
	nop
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lw		$v0, -32($fp)
	nop
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	slt		$v0, $t0, $v0
	xori	$v0, $v0, 1
	beq		$v0, $zero, _IF_2
	nop
# START if body
	j		_FOR_END_0
	nop
# END if body
	j		_IF_END_1
	nop
_IF_2:
_IF_END_1:
	addi		$t1, 0
	lw		$v0, -28($fp)
	nop
	lui		$t2, 65535
	ori		$t2, $t2, 65535
	mult	$t1, $t2
	mflo	$t1
	add		$t1, $t1, $v0
	lw		$v0, 8($fp)
	nop
	sll		$t1, $t1, 2
	add		$v0, $v0, $t1
	lw		$v0, 0($v0)
	nop
	sw		$v0, -36($fp)
	nop
	addi		$t0, 0
	lw		$v0, -28($fp)
	nop
	lui		$t1, 65535
	ori		$t1, $t1, 65535
	mult	$t0, $t1
	mflo	$t0
	add		$t0, $t0, $v0
	lw		$v0, 8($fp)
	nop
	sll		$t0, $t0, 2
	add		$v0, $v0, $t0
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	addi		$t1, 0
	lw		$v0, -32($fp)
	nop
	lui		$t2, 65535
	ori		$t2, $t2, 65535
	mult	$t1, $t2
	mflo	$t1
	add		$t1, $t1, $v0
	lw		$v0, 8($fp)
	nop
	sll		$t1, $t1, 2
	add		$v0, $v0, $t1
	lw		$v0, 0($v0)
	nop
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sw		$v0, 0($t0)
	nop
	addi		$t0, 0
	lw		$v0, -32($fp)
	nop
	lui		$t1, 65535
	ori		$t1, $t1, 65535
	mult	$t0, $t1
	mflo	$t0
	add		$t0, $t0, $v0
	lw		$v0, 8($fp)
	nop
	sll		$t0, $t0, 2
	add		$v0, $v0, $t0
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lw		$v0, -36($fp)
	nop
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sw		$v0, 0($t0)
	nop
# END for body
	j		_FOR_0
	nop
_FOR_END_0:
	addi		$t1, 0
	lw		$v0, -28($fp)
	nop
	lui		$t2, 65535
	ori		$t2, $t2, 65535
	mult	$t1, $t2
	mflo	$t1
	add		$t1, $t1, $v0
	lw		$v0, 8($fp)
	nop
	sll		$t1, $t1, 2
	add		$v0, $v0, $t1
	lw		$v0, 0($v0)
	nop
	sw		$v0, -36($fp)
	nop
	addi		$t0, 0
	lw		$v0, -28($fp)
	nop
	lui		$t1, 65535
	ori		$t1, $t1, 65535
	mult	$t0, $t1
	mflo	$t0
	add		$t0, $t0, $v0
	lw		$v0, 8($fp)
	nop
	sll		$t0, $t0, 2
	add		$v0, $v0, $t0
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	addi		$t1, 0
	lw		$v0, 16($fp)
	nop
	lui		$t2, 65535
	ori		$t2, $t2, 65535
	mult	$t1, $t2
	mflo	$t1
	add		$t1, $t1, $v0
	lw		$v0, 8($fp)
	nop
	sll		$t1, $t1, 2
	add		$v0, $v0, $t1
	lw		$v0, 0($v0)
	nop
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sw		$v0, 0($t0)
	nop
	addi		$t0, 0
	lw		$v0, 16($fp)
	nop
	lui		$t1, 65535
	ori		$t1, $t1, 65535
	mult	$t0, $t1
	mflo	$t0
	add		$t0, $t0, $v0
	lw		$v0, 8($fp)
	nop
	sll		$t0, $t0, 2
	add		$v0, $v0, $t0
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lw		$v0, -36($fp)
	nop
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sw		$v0, 0($t0)
	nop
	lw		$v0, -28($fp)
	nop
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lui		$v0, 0
	ori		$v0, $v0, 1
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sub		$v0, $t0, $v0	# SUB_AST
	addi	$sp, $sp, -4
	sw		$v0, 0($sp)
	nop
	lw		$v0, 12($fp)
	nop
	addi	$sp, $sp, -4
	sw		$v0, 0($sp)
	nop
	lw		$v0, 8($fp)
	nop
	addi	$sp, $sp, -4
	sw		$v0, 0($sp)
	nop
	jal		quicksort
	nop
	addi	$sp, $sp, 12
	lw		$v0, 16($fp)
	nop
	addi	$sp, $sp, -4
	sw		$v0, 0($sp)
	nop
	lw		$v0, -28($fp)
	nop
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lui		$v0, 0
	ori		$v0, $v0, 1
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	add		$v0, $t0, $v0	# ADD_AST
	addi	$sp, $sp, -4
	sw		$v0, 0($sp)
	nop
	lw		$v0, 8($fp)
	nop
	addi	$sp, $sp, -4
	sw		$v0, 0($sp)
	nop
	jal		quicksort
	nop
	addi	$sp, $sp, 12
# END if body
	j		_IF_END_0
	nop
_IF_1:
_IF_END_0:
	addi	$sp, $sp, 40
	lw		$ra, 0($sp)	# Call $ra
	lw		$fp, 4($sp)	# Call $fp
	addi	$sp, $sp, 8	# Colling convention
	jr		$ra
	nop
main:
	addi	$sp, $sp, -8	# Colling convention
	sw		$ra, 0($sp)	# Saving $ra
	sw		$fp, 4($sp)	# Saving $fp
	addi	$fp, $sp, 0
# Declare variable data, offset 40
	addi	$sp, $sp, -40	# allocate local variables
	addi		$t0, 0
	lui		$v0, 0
	ori		$v0, $v0, 0
	lui		$t1, 0
	ori		$t1, $t1, 10
	mult	$t0, $t1
	mflo	$t0
	add		$t0, $t0, $v0
	addi	$v0, $fp, -40
	sll		$t0, $t0, 2
	add		$v0, $v0, $t0
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lui		$v0, 0
	ori		$v0, $v0, 10
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sw		$v0, 0($t0)
	nop
	addi		$t0, 0
	lui		$v0, 0
	ori		$v0, $v0, 1
	lui		$t1, 0
	ori		$t1, $t1, 10
	mult	$t0, $t1
	mflo	$t0
	add		$t0, $t0, $v0
	addi	$v0, $fp, -40
	sll		$t0, $t0, 2
	add		$v0, $v0, $t0
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lui		$v0, 0
	ori		$v0, $v0, 4
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sw		$v0, 0($t0)
	nop
	addi		$t0, 0
	lui		$v0, 0
	ori		$v0, $v0, 2
	lui		$t1, 0
	ori		$t1, $t1, 10
	mult	$t0, $t1
	mflo	$t0
	add		$t0, $t0, $v0
	addi	$v0, $fp, -40
	sll		$t0, $t0, 2
	add		$v0, $v0, $t0
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lui		$v0, 0
	ori		$v0, $v0, 2
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sw		$v0, 0($t0)
	nop
	addi		$t0, 0
	lui		$v0, 0
	ori		$v0, $v0, 3
	lui		$t1, 0
	ori		$t1, $t1, 10
	mult	$t0, $t1
	mflo	$t0
	add		$t0, $t0, $v0
	addi	$v0, $fp, -40
	sll		$t0, $t0, 2
	add		$v0, $v0, $t0
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lui		$v0, 0
	ori		$v0, $v0, 7
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sw		$v0, 0($t0)
	nop
	addi		$t0, 0
	lui		$v0, 0
	ori		$v0, $v0, 4
	lui		$t1, 0
	ori		$t1, $t1, 10
	mult	$t0, $t1
	mflo	$t0
	add		$t0, $t0, $v0
	addi	$v0, $fp, -40
	sll		$t0, $t0, 2
	add		$v0, $v0, $t0
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lui		$v0, 0
	ori		$v0, $v0, 3
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sw		$v0, 0($t0)
	nop
	addi		$t0, 0
	lui		$v0, 0
	ori		$v0, $v0, 5
	lui		$t1, 0
	ori		$t1, $t1, 10
	mult	$t0, $t1
	mflo	$t0
	add		$t0, $t0, $v0
	addi	$v0, $fp, -40
	sll		$t0, $t0, 2
	add		$v0, $v0, $t0
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lui		$v0, 0
	ori		$v0, $v0, 5
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sw		$v0, 0($t0)
	nop
	addi		$t0, 0
	lui		$v0, 0
	ori		$v0, $v0, 6
	lui		$t1, 0
	ori		$t1, $t1, 10
	mult	$t0, $t1
	mflo	$t0
	add		$t0, $t0, $v0
	addi	$v0, $fp, -40
	sll		$t0, $t0, 2
	add		$v0, $v0, $t0
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lui		$v0, 0
	ori		$v0, $v0, 9
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sw		$v0, 0($t0)
	nop
	addi		$t0, 0
	lui		$v0, 0
	ori		$v0, $v0, 7
	lui		$t1, 0
	ori		$t1, $t1, 10
	mult	$t0, $t1
	mflo	$t0
	add		$t0, $t0, $v0
	addi	$v0, $fp, -40
	sll		$t0, $t0, 2
	add		$v0, $v0, $t0
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lui		$v0, 0
	ori		$v0, $v0, 10
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sw		$v0, 0($t0)
	nop
	addi		$t0, 0
	lui		$v0, 0
	ori		$v0, $v0, 8
	lui		$t1, 0
	ori		$t1, $t1, 10
	mult	$t0, $t1
	mflo	$t0
	add		$t0, $t0, $v0
	addi	$v0, $fp, -40
	sll		$t0, $t0, 2
	add		$v0, $v0, $t0
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lui		$v0, 0
	ori		$v0, $v0, 1
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sw		$v0, 0($t0)
	nop
	addi		$t0, 0
	lui		$v0, 0
	ori		$v0, $v0, 9
	lui		$t1, 0
	ori		$t1, $t1, 10
	mult	$t0, $t1
	mflo	$t0
	add		$t0, $t0, $v0
	addi	$v0, $fp, -40
	sll		$t0, $t0, 2
	add		$v0, $v0, $t0
	sw		$v0, -4($sp)
	addi	$sp, $sp, -4
	lui		$v0, 0
	ori		$v0, $v0, 8
	lw		$t0, 0($sp)
	addi	$sp, $sp, 4
	sw		$v0, 0($t0)
	nop
	lui		$v0, 0
	ori		$v0, $v0, 9
	addi	$sp, $sp, -4
	sw		$v0, 0($sp)
	nop
	lui		$v0, 0
	ori		$v0, $v0, 0
	addi	$sp, $sp, -4
	sw		$v0, 0($sp)
	nop
	addi	$v0, $fp, -40
	addi	$sp, $sp, -4
	sw		$v0, 0($sp)
	nop
	jal		quicksort
	nop
	addi	$sp, $sp, 12
	lw		$t0, -4($fp)	# data[9]
	lw		$t1, -8($fp)	# data[8]
	lw		$t2, -12($fp)	# data[7]
	lw		$t3, -16($fp)	# data[6]
	lw		$t4, -20($fp)	# data[5]
	lw		$t5, -24($fp)	# data[4]
	lw		$t6, -28($fp)	# data[3]
	lw		$t7, -32($fp)	# data[2]
	lw		$s0, -36($fp)	# data[1]
	lw		$s1, -40($fp)	# data[0]
	addi	$sp, $sp, 40
	lw		$ra, 0($sp)	# Call $ra
	lw		$fp, 4($sp)	# Call $fp
	addi	$sp, $sp, 8	# Colling convention
	jr		$ra
	nop
