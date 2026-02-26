#include "mips_common.h"

struct code program[MAX_LINES];
int total_lines = 0;
int nop_count = 0;

const char *oname_to_bit(OName op) {
    switch (op) {
        // R-type 命令 (OPECODE はすべて "000000") [cite: 6]
        case OPT_ADD:     return "000000";
        case OPT_ADDU:    return "000000";
        case OPT_SUB:     return "000000";
        case OPT_SUBU:    return "000000";
        case OPT_MULT:    return "000000";
        case OPT_MULTU:   return "000000";
        case OPT_DIV:     return "000000";
        case OPT_DIVU:    return "000000";
        case OPT_AND:     return "000000";
        case OPT_OR:      return "000000";
        case OPT_XOR:     return "000000";
        case OPT_NOR:     return "000000";
        case OPT_SLT:     return "000000";
        case OPT_SLTU:    return "000000";
        case OPT_SLL:     return "000000";
        case OPT_SRL:     return "000000";
        case OPT_SRA:     return "000000";
        case OPT_SLLV:    return "000000";
        case OPT_SRLV:    return "000000";
        case OPT_SRAV:    return "000000";
        case OPT_JR:      return "000000";
        case OPT_JALR:    return "000000";
        case OPT_MFHI:    return "000000";
        case OPT_MFLO:    return "000000";
        case OPT_SYSCALL: return "000000";
        case OPT_NOP:     return "000000";
        // I-type / J-type 命令 (固有の OPECODE)
        case OPT_ADDI:    return "001000";
        case OPT_ADDIU:   return "001001";
        case OPT_ANDI:    return "001100";
        case OPT_ORI:     return "001101";
        case OPT_XORI:    return "001110";
        case OPT_SLTI:    return "001010";
        case OPT_SLTIU:   return "001011";
        case OPT_BEQ:     return "000100";
        case OPT_BNE:     return "000101";
        case OPT_LB:      return "100000";
        case OPT_LW:      return "100011";
        case OPT_SB:      return "101000";
        case OPT_SW:      return "101011";
        case OPT_LUI:     return "001111";
        case OPT_J:       return "000010";
        case OPT_JAL:     return "000011";
        default:          return "000000"; 
    }
}
const char *oname_to_funct(OName op) {
    switch (op) {
        case OPT_ADD:     return "100000";
        case OPT_ADDU:    return "100001";
        case OPT_SUB:     return "100010";
        case OPT_SUBU:    return "100011";
        case OPT_MULT:    return "011000";
        case OPT_MULTU:   return "011001";
        case OPT_DIV:     return "011010";
        case OPT_DIVU:    return "011011";
        case OPT_AND:     return "100100";
        case OPT_OR:      return "100101";
        case OPT_XOR:     return "100110";
        case OPT_NOR:     return "100111";
        case OPT_SLT:     return "101010";
        case OPT_SLTU:    return "101011";
        case OPT_SLL:     return "000000";
        case OPT_SRL:     return "000010";
        case OPT_SRA:     return "000011";
        case OPT_SLLV:    return "000100";
        case OPT_SRLV:    return "000110";
        case OPT_SRAV:    return "000111";
        case OPT_JR:      return "001000";
        case OPT_JALR:    return "001001";
        case OPT_MFHI:    return "010000";
        case OPT_MFLO:    return "010010";
        case OPT_SYSCALL: return "001100";
        case OPT_NOP:     return "000000";
        default:          return "000000";
    }
}
OName string_to_oname(const char *s) {
    if (!s) return OPT_UNKNOWN;
    if (!strcmp(s, "add"))     return OPT_ADD;
    if (!strcmp(s, "addu"))    return OPT_ADDU;
    if (!strcmp(s, "addi"))    return OPT_ADDI;
    if (!strcmp(s, "addiu"))   return OPT_ADDIU;
    if (!strcmp(s, "sub"))     return OPT_SUB;
    if (!strcmp(s, "subu"))    return OPT_SUBU;
    if (!strcmp(s, "mult"))    return OPT_MULT;
    if (!strcmp(s, "multu"))   return OPT_MULTU;
    if (!strcmp(s, "div"))     return OPT_DIV;
    if (!strcmp(s, "divu"))    return OPT_DIVU;
    if (!strcmp(s, "and"))     return OPT_AND;
    if (!strcmp(s, "andi"))    return OPT_ANDI;
    if (!strcmp(s, "or"))      return OPT_OR;
    if (!strcmp(s, "ori"))     return OPT_ORI;
    if (!strcmp(s, "xor"))     return OPT_XOR;
    if (!strcmp(s, "xori"))    return OPT_XORI;
    if (!strcmp(s, "nor"))     return OPT_NOR;
    if (!strcmp(s, "slt"))     return OPT_SLT;
    if (!strcmp(s, "sltu"))    return OPT_SLTU;
    if (!strcmp(s, "slti"))    return OPT_SLTI;
    if (!strcmp(s, "sltiu"))   return OPT_SLTIU;
    if (!strcmp(s, "lb"))      return OPT_LB;
    if (!strcmp(s, "lw"))      return OPT_LW;
    if (!strcmp(s, "sb"))      return OPT_SB;
    if (!strcmp(s, "sw"))      return OPT_SW;
    if (!strcmp(s, "sll"))     return OPT_SLL;
    if (!strcmp(s, "srl"))     return OPT_SRL;
    if (!strcmp(s, "sra"))     return OPT_SRA;
    if (!strcmp(s, "sllv"))    return OPT_SLLV;
    if (!strcmp(s, "srlv"))    return OPT_SRLV;
    if (!strcmp(s, "srav"))    return OPT_SRAV;
    if (!strcmp(s, "beq"))     return OPT_BEQ;
    if (!strcmp(s, "bne"))     return OPT_BNE;
    if (!strcmp(s, "j"))       return OPT_J;
    if (!strcmp(s, "jal"))     return OPT_JAL;
    if (!strcmp(s, "jr"))      return OPT_JR;
    if (!strcmp(s, "jalr"))    return OPT_JALR;
    if (!strcmp(s, "lui"))     return OPT_LUI;
    if (!strcmp(s, "mfhi"))    return OPT_MFHI;
    if (!strcmp(s, "mflo"))    return OPT_MFLO;
    if (!strcmp(s, "syscall")) return OPT_SYSCALL;
    if (!strcmp(s, "li"))      return OPT_LI;
    if (!strcmp(s, "la"))      return OPT_LA;
    if (!strcmp(s, "nop"))     return OPT_NOP;
    if (!strcmp(s, ".text"))   return DIR_TEXT;
    if (!strcmp(s, ".data"))   return DIR_DATA;
    if (!strcmp(s, ".word"))   return DIR_WORD;
    if (!strcmp(s, ".byte"))   return DIR_BYTE;
    if (!strcmp(s, ".ascii"))  return DIR_ASCII;
    if (!strcmp(s, ".asciiz")) return DIR_ASCIIZ;
    if (!strcmp(s, ".space"))  return DIR_SPACE;
    return OPT_UNKNOWN;
}
int is_r_type(OName op)
{
    switch (op) {
        case OPT_ADD: case OPT_ADDU: case OPT_SUB: case OPT_SUBU:
        case OPT_AND: case OPT_OR: case OPT_XOR: case OPT_NOR:
        case OPT_SLT: case OPT_SLTU: case OPT_SLLV: case OPT_SRLV: case OPT_SRAV:
        case OPT_MULT: case OPT_MULTU: case OPT_DIV: case OPT_DIVU: // 追加
        case OPT_SLL: case OPT_SRL: case OPT_SRA: // 追加
        case OPT_JR: case OPT_JALR: // 追加
        case OPT_MFHI: case OPT_MFLO: // 追加
            return 1;
        default:
            return 0;
    }
}
int is_i_type(OName op)
{
    switch (op) {
        case OPT_ADDI: case OPT_ADDIU: case OPT_ANDI: case OPT_ORI: case OPT_XORI:
        case OPT_SLTI: case OPT_SLTIU:
        case OPT_LUI: // LUIを追加（パス2で確実にエンコードさせるため）
            return 1;
        default:
            return 0;
    }
}
int is_mem_type(OName op)
{
    switch (op) {
        case OPT_LW:
        case OPT_SW:
        case OPT_LB:
        case OPT_SB:
            return 1;
        default:
            return 0;
    }
}
int is_rt_imm(OName op)
{
    return (op == OPT_LI || op == OPT_LUI);
}
int is_branch_or_jump(OName op)
{
    switch (op) {
        case OPT_BEQ:
        case OPT_BNE:
        case OPT_J:
        case OPT_JAL:
        case OPT_JR:
        case OPT_JALR:
            return 1;
        default:
            return 0;
    }
}
int is_label_etc(OName op)
{
    if (op >= DIR_TEXT) return 1;
    return 0;
}
const char *rname_to_bit(RName r) {
    switch (r) {
        case REG_ZERO: return "00000";
        case REG_AT:   return "00001";
        case REG_V0:   return "00010";
        case REG_V1:   return "00011";
        case REG_A0:   return "00100";
        case REG_A1:   return "00101";
        case REG_A2:   return "00110";
        case REG_A3:   return "00111";
        case REG_T0:   return "01000";
        case REG_T1:   return "01001";
        case REG_T2:   return "01010";
        case REG_T3:   return "01011";
        case REG_T4:   return "01100";
        case REG_T5:   return "01101";
        case REG_T6:   return "01110";
        case REG_T7:   return "01111";
        case REG_S0:   return "10000";
        case REG_S1:   return "10001";
        case REG_S2:   return "10010";
        case REG_S3:   return "10011";
        case REG_S4:   return "10100";
        case REG_S5:   return "10101";
        case REG_S6:   return "10110";
        case REG_S7:   return "10111";
        case REG_T8:   return "11000";
        case REG_T9:   return "11001";
        case REG_K0:   return "11010";
        case REG_K1:   return "11011";
        case REG_GP:   return "11100";
        case REG_SP:   return "11101";
        case REG_FP:   return "11110";
        case REG_RA:   return "11111";
        default:       return "invalid";
    }
}
RName string_to_rname(const char *s) {
    if (!s) return REG_INVALID;
    if (!strcmp(s, "$zero")) return REG_ZERO;
    if (!strcmp(s, "$at"))   return REG_AT;
    if (!strcmp(s, "$v0"))   return REG_V0;
    if (!strcmp(s, "$v1"))   return REG_V1;
    if (!strcmp(s, "$a0"))   return REG_A0;
    if (!strcmp(s, "$a1"))   return REG_A1;
    if (!strcmp(s, "$a2"))   return REG_A2;
    if (!strcmp(s, "$a3"))   return REG_A3;
    if (!strcmp(s, "$t0"))   return REG_T0;
    if (!strcmp(s, "$t1"))   return REG_T1;
    if (!strcmp(s, "$t2"))   return REG_T2;
    if (!strcmp(s, "$t3"))   return REG_T3;
    if (!strcmp(s, "$t4"))   return REG_T4;
    if (!strcmp(s, "$t5"))   return REG_T5;
    if (!strcmp(s, "$t6"))   return REG_T6;
    if (!strcmp(s, "$t7"))   return REG_T7;
    if (!strcmp(s, "$s0"))   return REG_S0;
    if (!strcmp(s, "$s1"))   return REG_S1;
    if (!strcmp(s, "$s2"))   return REG_S2;
    if (!strcmp(s, "$s3"))   return REG_S3;
    if (!strcmp(s, "$s4"))   return REG_S4;
    if (!strcmp(s, "$s5"))   return REG_S5;
    if (!strcmp(s, "$s6"))   return REG_S6;
    if (!strcmp(s, "$s7"))   return REG_S7;
    if (!strcmp(s, "$t8"))   return REG_T8;
    if (!strcmp(s, "$t9"))   return REG_T9;
    if (!strcmp(s, "$k0"))   return REG_K0;
    if (!strcmp(s, "$k1"))   return REG_K1;
    if (!strcmp(s, "$gp"))   return REG_GP;
    if (!strcmp(s, "$sp"))   return REG_SP;
    if (!strcmp(s, "$fp"))   return REG_FP;
    if (!strcmp(s, "$ra"))   return REG_RA;
    return REG_INVALID;
}

int subst(char *str, char c1, char c2)
{
    int n = 0;
    while (*str)
    {
        if (*str == c1)
        {
            *str = c2;
            n++;
        }
        str++;
    }
    return n;
}
int get_line(FILE *fp, char *line)
{
    if(fgets(line, MAX_LEN + 1, fp) == NULL) return 0;
    subst(line, '\n', '\0');
    return 1;
}
void parse_mem_operand(const char *s, int *imm, int *has_imm, char **label, RName *rs)
{
    char buf[64];
    strcpy(buf, s);
    char *l = strchr(buf, '(');
    char *r = strchr(buf, ')');
    if (!l || !r) return;
    *l = '\0';
    char reg[16];
    strncpy(reg, l + 1, r - l - 1);
    reg[r - l - 1] = '\0';
    *rs = string_to_rname(reg);
    char *endp;
    long v = strtol(buf, &endp, 0);
    if (*endp == '\0') {
        *imm = (int)v;
        *has_imm = 1;
    } else {
        *label = strdup(buf);
        *has_imm = 0;
    }
}

int parse_line_to_mips(const char *line, struct MIPS *m)
{
    m->raw = strdup(line);
    char buf[MAX_LEN];
    char *tokens[4];
    int ntok = 0;
    memset(buf, 0, sizeof(buf)); 
    strcpy(buf, line);
    
    // 【重要】デフォルト値で初期化（ゴミデータによるバグや、レジスタ指定無しの命令を防ぐ）
    m->rs = REG_ZERO; m->rt = REG_ZERO; m->rd = REG_ZERO;
    m->imm = 0; m->has_imm = 0; m->label = NULL;

    char *tok = strtok(buf, " ,\n\t");
    while (tok && ntok < 4) {
        tokens[ntok++] = tok;
        tok = strtok(NULL, " ,\n\t");
    }
    if (ntok == 0) {
        m->ope = OPT_UNKNOWN;
        return 1;
    }
    m->ope = string_to_oname(tokens[0]);
    if (m->ope == OPT_UNKNOWN) return 1;

    // 命令の形に合わせて適切にパースする
    if (m->ope == OPT_J || m->ope == OPT_JAL) { // j, jal (例: j LOOP)
        if (ntok >= 2) m->label = strdup(tokens[1]);
    }
    else if (m->ope == OPT_JR) { // jr (例: jr $ra)
        if (ntok >= 2) m->rs = string_to_rname(tokens[1]);
    }
    else if (m->ope == OPT_MFHI || m->ope == OPT_MFLO) { // mfhi, mflo (例: mflo $t0)
        if (ntok >= 2) m->rd = string_to_rname(tokens[1]);
    }
    else if (m->ope == OPT_LUI) { // lui (例: lui $t2, 65535)
        if (ntok >= 3) {
            m->rt = string_to_rname(tokens[1]);
            m->imm = atoi(tokens[2]);
        }
    }
    else if (m->ope == OPT_MULT || m->ope == OPT_DIV || m->ope == OPT_MULTU || m->ope == OPT_DIVU) { // mult (例: mult $t1, $t2)
        if (ntok >= 3) {
            m->rs = string_to_rname(tokens[1]);
            m->rt = string_to_rname(tokens[2]);
        }
    }
    else if (m->ope == OPT_BEQ || m->ope == OPT_BNE) { // beq (例: beq $v0, $zero, _IF_1)
        if (ntok >= 4) {
            m->rs = string_to_rname(tokens[1]);
            m->rt = string_to_rname(tokens[2]);
            m->label = strdup(tokens[3]);
        }
    }
    else if (is_mem_type(m->ope) && ntok >= 3) { // lw, sw (例: lw $v0, 16($fp))
        m->rt = string_to_rname(tokens[1]);
        parse_mem_operand(tokens[2], &m->imm, &m->has_imm, &m->label, &m->rs);
    }
    else if (m->ope == OPT_LI) { // li $t0, 5 を addi $t0, $zero, 5 に変換
        if (ntok >= 3) {
            m->ope = OPT_ADDI; // 内部的には addi として扱う
            m->rt = string_to_rname(tokens[1]);
            m->rs = REG_ZERO;  // rs は常に $zero
            m->imm = atoi(tokens[2]);
        }
    }
    else if (is_r_type(m->ope)) { 
        // 通常の R-type または シフト演算 (例: add $t1, $t1, $v0  /  sll $t1, $t1, 2)
        if (ntok >= 4) {
            m->rd = string_to_rname(tokens[1]);
            if (m->ope == OPT_SLL || m->ope == OPT_SRL || m->ope == OPT_SRA) {
                m->rt = string_to_rname(tokens[2]);
                m->imm = atoi(tokens[3]); // shamtとして使用
            } else {
                m->rs = string_to_rname(tokens[2]);
                m->rt = string_to_rname(tokens[3]);
            }
        }
    }
    else if (is_i_type(m->ope)) {
        if (ntok >= 4) { // addi $t0, $zero, 5
            m->rt  = string_to_rname(tokens[1]);
            m->rs  = string_to_rname(tokens[2]);
            m->imm = atoi(tokens[3]);
        } else if (ntok == 3) { // addi $t0, 5 (rsが省略された場合)
            m->rt  = string_to_rname(tokens[1]);
            m->rs  = REG_ZERO; // 省略されたら $zero を補う
            m->imm = atoi(tokens[2]);
        }
    }
    
    return 1;
}

void load_all_code(FILE *fp) {
    total_lines = 0;
    char line[MAX_LEN];
    while (get_line(fp, line)) {
        struct MIPS temp_m;
        memset(&temp_m, 0, sizeof(struct MIPS));
        if (parse_line_to_mips(line, &temp_m)) { 
             program[total_lines].m = temp_m;
             program[total_lines].alive = 1;
             total_lines++;
        }
    }
}