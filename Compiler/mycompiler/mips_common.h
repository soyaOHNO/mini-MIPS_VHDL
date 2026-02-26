// mips_common.h
#ifndef MIPS_COMMON_H
#define MIPS_COMMON_H
#define MAX_LINES 1024
#define MAX_LEN 1024
#define MAX_LABEL_LEN 32

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// 重複していた OName, RName, MIPS構造体などの定義をここに移す
typedef enum {
    OPT_ADD,
    OPT_ADDU,
    OPT_ADDI,
    OPT_ADDIU,
    OPT_SUB,
    OPT_SUBU,
    OPT_MULT,
    OPT_MULTU,
    OPT_DIV,
    OPT_DIVU,
    OPT_AND,
    OPT_ANDI,
    OPT_OR,
    OPT_ORI,
    OPT_XOR,
    OPT_XORI,
    OPT_NOR,
    OPT_SLT,
    OPT_SLTU,
    OPT_SLTI,
    OPT_SLTIU,
    OPT_LB,
    OPT_LW,
    OPT_SB,
    OPT_SW,
    OPT_SLL,
    OPT_SRL,
    OPT_SRA,
    OPT_SLLV,
    OPT_SRLV,
    OPT_SRAV,
    OPT_BEQ,
    OPT_BNE,
    OPT_J,
    OPT_JAL,
    OPT_JR,
    OPT_JALR,
    OPT_LUI,
    OPT_MFHI,
    OPT_MFLO,
    OPT_SYSCALL,
    OPT_LI,
    OPT_LA,
    OPT_NOP,
    DIR_TEXT,
    DIR_DATA,
    DIR_WORD,
    DIR_BYTE,
    DIR_ASCII,
    DIR_ASCIIZ,
    DIR_SPACE,
    OPT_UNKNOWN
} OName;
typedef enum {
    REG_ZERO,
    REG_AT,
    REG_V0,
    REG_V1,
    REG_A0,
    REG_A1,
    REG_A2,
    REG_A3,
    REG_T0,
    REG_T1,
    REG_T2,
    REG_T3,
    REG_T4,
    REG_T5,
    REG_T6,
    REG_T7,
    REG_S0,
    REG_S1,
    REG_S2,
    REG_S3,
    REG_S4,
    REG_S5,
    REG_S6,
    REG_S7,
    REG_T8,
    REG_T9,
    REG_K0,
    REG_K1,
    REG_GP,
    REG_SP,
    REG_FP,
    REG_RA,
    REG_INVALID
} RName;

struct MIPS {
    OName ope;
    RName rd;
    RName rs;
    RName rt;
    int imm;
    int has_imm;
    char *label;
    char *raw;
};
struct code {
    int alive;
    struct MIPS m;
};

// ラベル管理用
typedef struct {
    char name[MAX_LABEL_LEN];   // ラベル名（例: "main"）
    int addr;                   // ラベルのアドレス
} Label;

// 展開後の命令保持用
typedef struct {
    char addr[8];   // アドレス（例: "004"）
    char inst[16];   // 命令（例: "23BE0000"）
    char *dst;      // 元の命令（例: "addi $fp, $sp, 0"）
} Instruction;

// 共通関数のプロトタイプ宣言
OName string_to_oname(const char *s);
RName string_to_rname(const char *s);
int is_r_type(OName op);
int is_i_type(OName op);
int is_mem_type(OName op);
int is_branch_or_jump(OName op);
int is_label_etc(OName op);
int parse_line_to_mips(const char *line, struct MIPS *m);
const char *oname_to_bit(OName op);
const char *oname_to_funct(OName op);
const char *rname_to_bit(RName r);

int subst(char *str, char c1, char c2);
int get_line(FILE *fp, char *line);
void parse_mem_operand(const char *s, int *imm, int *has_imm, char **label, RName *rs);
void load_all_code(FILE *fp);

extern struct code program[MAX_LINES];
extern int total_lines;
extern int nop_count;

#endif