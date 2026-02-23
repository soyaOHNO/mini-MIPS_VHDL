import re

# 実行するアセンブリコード
# (PC=0の初期化コード + ユーザーのQuick Sortコード)
asm_source = """
_start:
    addi   $sp, $zero, 1024  # スタックの底を1024番地に設定 (DataMemを拡張した前提)
    addi   $fp, $sp, 0
    jal    main
    nop
_end:
    j      _end              # 処理終了後の無限ループ
    nop

# --- 以下の行からQuick Sortのコード ---
quicksort:
	addi   $sp, $sp, -8
	sw     $ra, 0($sp)
	sw     $fp, 4($sp)
	addi   $fp, $sp, 0
	addi   $sp, $sp, -40
	lw     $t1, 16($fp)
	lw     $t2, 12($fp)
	nop
	slt    $t0, $t2, $t1
	beq    $t0, $zero, _IF_1
	nop
	li     $t1, 0
	lw     $t3, 16($fp)
	li     $t2, -1
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	lw     $t0, 8($fp)
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	lw     $v0, 0($t0)
	nop
	sw     $v0, -24($fp)
	lw     $t0, 12($fp)
	nop
	sw     $t0, -4($sp)
	addi   $sp, $sp, -4
	li     $t0, 1
	lw     $t1, 0($sp)
	addi   $sp, $sp, 4
	sub    $v0, $t1, $t0
	sw     $v0, -28($fp)
	lw     $v0, 16($fp)
	nop
	sw     $v0, -32($fp)
_FOR_0:
_WHILE_0:
	li     $t3, 0
	lw     $t6, -28($fp)
	nop
	addi   $t6, $t6, 1
	sw     $t6, -28($fp)
	addi   $t5, $t6, 0
	li     $t4, -1
	mult   $t3, $t4
	mflo   $t3
	add    $t3, $t3, $t5
	lw     $t2, 8($fp)
	sll    $t3, $t3, 2
	add    $t2, $t2, $t3
	lw     $t1, 0($t2)
	lw     $t2, -24($fp)
	nop
	slt    $t0, $t1, $t2
	beq    $t0, $zero, _WHILE_END_0
	nop
	j      _WHILE_0
	nop
_WHILE_END_0:
_WHILE_1:
	li     $t3, 0
	lw     $t6, -32($fp)
	nop
	addi   $t6, $t6, -1
	sw     $t6, -32($fp)
	addi   $t5, $t6, 0
	li     $t4, -1
	mult   $t3, $t4
	mflo   $t3
	add    $t3, $t3, $t5
	lw     $t2, 8($fp)
	sll    $t3, $t3, 2
	add    $t2, $t2, $t3
	lw     $t1, 0($t2)
	lw     $t2, -24($fp)
	nop
	slt    $t0, $t2, $t1
	beq    $t0, $zero, _WHILE_END_1
	nop
	j      _WHILE_1
	nop
_WHILE_END_1:
	lw     $t1, -28($fp)
	lw     $t2, -32($fp)
	nop
	slt    $t0, $t1, $t2
	xori   $t0, $t0, 1
	beq    $t0, $zero, _IF_2
	nop
	j      _FOR_END_0
	nop
	j      _IF_END_1
	nop
_IF_2:
_IF_END_1:
	li     $t1, 0
	lw     $t3, -28($fp)
	li     $t2, -1
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	lw     $t0, 8($fp)
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	lw     $v0, 0($t0)
	nop
	sw     $v0, -36($fp)
	li     $t1, 0
	lw     $t3, -28($fp)
	li     $t2, -1
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	lw     $t0, 8($fp)
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	li     $t2, 0
	lw     $t4, -32($fp)
	li     $t3, -1
	mult   $t2, $t3
	mflo   $t2
	add    $t2, $t2, $t4
	lw     $t1, 8($fp)
	sll    $t2, $t2, 2
	add    $t1, $t1, $t2
	lw     $v0, 0($t1)
	nop
	sw     $v0, 0($t0)
	li     $t1, 0
	lw     $t3, -32($fp)
	li     $t2, -1
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	lw     $t0, 8($fp)
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	lw     $v0, -36($fp)
	nop
	sw     $v0, 0($t0)
	j      _FOR_0
	nop
_FOR_END_0:
	li     $t1, 0
	lw     $t3, -28($fp)
	li     $t2, -1
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	lw     $t0, 8($fp)
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	lw     $v0, 0($t0)
	nop
	sw     $v0, -36($fp)
	li     $t1, 0
	lw     $t3, -28($fp)
	li     $t2, -1
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	lw     $t0, 8($fp)
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	li     $t2, 0
	lw     $t4, 16($fp)
	li     $t3, -1
	mult   $t2, $t3
	mflo   $t2
	add    $t2, $t2, $t4
	lw     $t1, 8($fp)
	sll    $t2, $t2, 2
	add    $t1, $t1, $t2
	lw     $v0, 0($t1)
	nop
	sw     $v0, 0($t0)
	li     $t1, 0
	lw     $t3, 16($fp)
	li     $t2, -1
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	lw     $t0, 8($fp)
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	lw     $v0, -36($fp)
	nop
	sw     $v0, 0($t0)
	lw     $t0, -28($fp)
	nop
	sw     $t0, -4($sp)
	addi   $sp, $sp, -4
	li     $t0, 1
	lw     $t1, 0($sp)
	addi   $sp, $sp, 4
	sub    $v0, $t1, $t0
	addi   $sp, $sp, -4
	sw     $v0, 0($sp)
	lw     $v0, 12($fp)
	addi   $sp, $sp, -4
	sw     $v0, 0($sp)
	lw     $v0, 8($fp)
	addi   $sp, $sp, -4
	sw     $v0, 0($sp)
	jal    quicksort
	nop
	addi   $sp, $sp, 12
	lw     $v0, 16($fp)
	addi   $sp, $sp, -4
	sw     $v0, 0($sp)
	lw     $t0, -28($fp)
	nop
	sw     $t0, -4($sp)
	addi   $sp, $sp, -4
	li     $t0, 1
	lw     $t1, 0($sp)
	addi   $sp, $sp, 4
	add    $v0, $t1, $t0
	addi   $sp, $sp, -4
	sw     $v0, 0($sp)
	lw     $v0, 8($fp)
	addi   $sp, $sp, -4
	sw     $v0, 0($sp)
	jal    quicksort
	nop
	addi   $sp, $sp, 12
	j      _IF_END_0
	nop
_IF_1:
_IF_END_0:
	addi   $sp, $sp, 40
	lw     $ra, 0($sp)
	lw     $fp, 4($sp)
	addi   $sp, $sp, 8
	jr     $ra
	nop
main:
	addi   $sp, $sp, -8
	sw     $ra, 0($sp)
	sw     $fp, 4($sp)
	addi   $fp, $sp, 0
	addi   $sp, $sp, -40
	li     $t1, 0
	li     $t3, 0
	li     $t2, 10
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	addi   $t0, $fp, -40
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	li     $v0, 10
	sw     $v0, 0($t0)
	li     $t1, 0
	li     $t3, 1
	li     $t2, 10
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	addi   $t0, $fp, -40
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	li     $v0, 4
	sw     $v0, 0($t0)
	li     $t1, 0
	li     $t3, 2
	li     $t2, 10
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	addi   $t0, $fp, -40
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	li     $v0, 2
	sw     $v0, 0($t0)
	li     $t1, 0
	li     $t3, 3
	li     $t2, 10
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	addi   $t0, $fp, -40
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	li     $v0, 7
	sw     $v0, 0($t0)
	li     $t1, 0
	li     $t3, 4
	li     $t2, 10
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	addi   $t0, $fp, -40
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	li     $v0, 3
	sw     $v0, 0($t0)
	li     $t1, 0
	li     $t3, 5
	li     $t2, 10
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	addi   $t0, $fp, -40
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	li     $v0, 5
	sw     $v0, 0($t0)
	li     $t1, 0
	li     $t3, 6
	li     $t2, 10
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	addi   $t0, $fp, -40
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	li     $v0, 9
	sw     $v0, 0($t0)
	li     $t1, 0
	li     $t3, 7
	li     $t2, 10
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	addi   $t0, $fp, -40
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	li     $v0, 10
	sw     $v0, 0($t0)
	li     $t1, 0
	li     $t3, 8
	li     $t2, 10
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	addi   $t0, $fp, -40
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	li     $v0, 1
	sw     $v0, 0($t0)
	li     $t1, 0
	li     $t3, 9
	li     $t2, 10
	mult   $t1, $t2
	mflo   $t1
	add    $t1, $t1, $t3
	addi   $t0, $fp, -40
	sll    $t1, $t1, 2
	add    $t0, $t0, $t1
	li     $v0, 8
	sw     $v0, 0($t0)
	li     $v0, 9
	addi   $sp, $sp, -4
	sw     $v0, 0($sp)
	li     $v0, 0
	addi   $sp, $sp, -4
	sw     $v0, 0($sp)
	addi   $v0, $fp, -40
	addi   $sp, $sp, -4
	sw     $v0, 0($sp)
	jal    quicksort
	nop
	addi   $sp, $sp, 12
"""

def assemble(source):
    lines = source.split('\n')
    labels = {}
    expanded_code = []
    
    # 【パス1】コメント削除・ラベルの記録・疑似命令の展開
    for line in lines:
        line = line.split('#')[0].strip()
        if not line: continue
        
        # ラベル処理
        if ':' in line:
            label, rest = line.split(':', 1)
            labels[label.strip()] = len(expanded_code)
            line = rest.strip()
            if not line: continue
            
        parts = re.split(r'[\s,]+', line)
        
        # 疑似命令の展開
        if parts[0] == 'li':    # li $reg, imm -> addi $reg, $zero, imm
            expanded_code.append(['addi', parts[1], '$zero', parts[2]])
        elif parts[0] == 'nop': # nop -> sll $zero, $zero, 0
            expanded_code.append(['sll', '$zero', '$zero', '0'])
        else:
            expanded_code.append(parts)
            
    # レジスタ名を番号に変換するヘルパー関数
    def reg(r):
        r = r.replace('$', '')
        reg_map = {'zero':0, 'v0':2, 't0':8, 't1':9, 't2':10, 't3':11, 't4':12, 't5':13, 't6':14, 'sp':29, 'fp':30, 'ra':31}
        return reg_map.get(r, 0)

    machine_code = []
    
    # 【パス2】機械語への変換
    for i, parts in enumerate(expanded_code):
        op = parts[0]
        code = 0
        
        try:
            # Rフォーマット (add, sub, slt)
            if op in ['add', 'sub', 'slt']:
                rd, rs, rt = reg(parts[1]), reg(parts[2]), reg(parts[3])
                funct = {'add':0x20, 'sub':0x22, 'slt':0x2a}[op]
                code = (0 << 26) | (rs << 21) | (rt << 16) | (rd << 11) | funct
                
            # Rフォーマット (mult)
            elif op == 'mult':
                rs, rt = reg(parts[1]), reg(parts[2])
                code = (0 << 26) | (rs << 21) | (rt << 16) | 0x18
                
            # Rフォーマット (mflo)
            elif op == 'mflo':
                rd = reg(parts[1])
                code = (0 << 26) | (rd << 11) | 0x12
                
            # Rフォーマット (sll)
            elif op == 'sll':
                rd, rt, shamt = reg(parts[1]), reg(parts[2]), int(parts[3])
                code = (0 << 26) | (rt << 16) | (rd << 11) | ((shamt & 0x1F) << 6) | 0x00
                
            # Rフォーマット (jr)
            elif op == 'jr':
                rs = reg(parts[1])
                code = (0 << 26) | (rs << 21) | 0x08
                
            # Iフォーマット (addi, xori)
            elif op in ['addi', 'xori']:
                rt, rs, imm = reg(parts[1]), reg(parts[2]), int(parts[3])
                opcode = {'addi':0x08, 'xori':0x0e}[op]
                code = (opcode << 26) | (rs << 21) | (rt << 16) | (imm & 0xFFFF)
                
            # Iフォーマット (beq, bne)
            elif op in ['beq', 'bne']:
                rs, rt, label = reg(parts[1]), reg(parts[2]), parts[3]
                opcode = {'beq':0x04, 'bne':0x05}[op]
                offset = labels[label] - i - 1  # 相対アドレス計算
                code = (opcode << 26) | (rs << 21) | (rt << 16) | (offset & 0xFFFF)
                
            # Iフォーマット (lw, sw)
            elif op in ['lw', 'sw']:
                rt = reg(parts[1])
                match = re.match(r'(-?\d+)\((.+)\)', parts[2])
                imm, rs = int(match.group(1)), reg(match.group(2))
                opcode = {'lw':0x23, 'sw':0x2b}[op]
                code = (opcode << 26) | (rs << 21) | (rt << 16) | (imm & 0xFFFF)
                
            # Jフォーマット (j, jal)
            elif op in ['j', 'jal']:
                label = parts[1]
                opcode = {'j':0x02, 'jal':0x03}[op]
                target = labels[label]  # 絶対アドレス(ワードインデックス)
                code = (opcode << 26) | (target & 0x3FFFFFF)
                
            else:
                print(f"-- Warning: Unknown instruction '{op}' at line {i}")
                
        except Exception as e:
            print(f"-- Error parsing '{' '.join(parts)}' at line {i}: {e}")
            
        machine_code.append(code)
        
    return machine_code

# メイン処理：変換してMIF形式で標準出力
if __name__ == "__main__":
    mcode = assemble(asm_source)
    
    print("-- Quartus Prime generated Memory Initialization File (.mif)")
    print("WIDTH=32;")
    print("DEPTH=1024; -- DataMem拡張に合わせて容量変更")
    print("ADDRESS_RADIX=HEX;")
    print("DATA_RADIX=HEX;\n")
    print("CONTENT BEGIN")
    
    for i, code in enumerate(mcode):
        print(f"    {i:03X} : {code:08X};")
        
    print(f"    [{len(mcode):03X}..3FF] : 00000000;")
    print("END;")