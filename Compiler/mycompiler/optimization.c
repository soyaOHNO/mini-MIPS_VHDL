#include "mips_common.h"

void emit_mips(FILE *fp, struct MIPS *m)
{
    // 最適化では命令自体を書き換えないので、元の文字列をそのまま出力するのが一番安全
    if (m->raw) {
        fprintf(fp, "%s\n", m->raw);
    }
}
void emit_all(FILE *nfp) {
    for (int i = 0; i < total_lines; i++) {
        if (program[i].alive) {
            emit_mips(nfp, &program[i].m);
        }
    }
}

int uses_register(struct MIPS *pr, struct MIPS *ne)
{
    RName reg;
    if (pr->ope == OPT_LW || pr->ope == OPT_LB) {
        reg = pr->rt;
        if (is_r_type(ne->ope)) {
            if (ne->rs == reg) return 1;
            if (ne->rt == reg) return 1;
            return 0;
        }
        if (is_i_type(ne->ope)) {
            if (ne->rs == reg) return 1;
            return 0;
        }
        if (ne->ope == OPT_SW || ne->ope == OPT_SB) {
            if (ne->rt == reg) return 1;
            return 0;
        }
        if (ne->ope == OPT_BEQ || ne->ope == OPT_BNE) {
            if (ne->rs == reg) return 1;
            if (ne->rt == reg) return 1;
            return 0;
        }
        if (ne->ope == OPT_JR || ne->ope == OPT_JALR) {
            if (ne->rs == reg) return 1;
        }
        return 0;
    }
    if (pr->ope == OPT_SW || pr->ope == OPT_SB) {
        reg = pr->rs;
        if (ne->ope == OPT_LW || ne->ope == OPT_LB) {
            if (ne->rs == reg && pr->imm == ne->imm) return 1;
            return 0;
        }
        return 0;
    }

    return 0;
}
int is_safe_nop(struct MIPS *prev, struct MIPS *next) {
    // 1で消す　0で残す
    if (!prev) return 1;
    if (is_branch_or_jump(prev->ope)) return 0;
    if (is_mem_type(prev->ope) && next) {
        if (uses_register(prev, next)) return 0;
    }
    return 1;
}

int get_alive_index(int current_index, int max_index, int a) {
    if (a > 0){
        for (int i = current_index + 1; i < max_index; i++) {
            if (program[i].alive) {
                if (is_label_etc(program[i].m.ope)) continue;
                return i;
            }
        }
    } else {
        for (int i = current_index - 1; i >= 0; i--) {
            if (program[i].alive) {
                if (is_label_etc(program[i].m.ope)) continue;
                return i;
            }
        }
    }
    return -1;
}
void optimize_nop() {
    for (int i = 0; i < total_lines; i++) {
        if (!program[i].alive) continue;

        if (program[i].m.ope == OPT_NOP) {
            int prev_idx = get_alive_index(i, total_lines, -1);
            int next_idx = get_alive_index(i, total_lines, 1);
            struct MIPS *prev_m = NULL;
            struct MIPS *next_m = NULL;
            if (!(prev_idx < 0 && next_idx >= 0)) prev_m = &program[prev_idx].m;
            if (!(prev_idx >=0 && next_idx < 0)) next_m = &program[next_idx].m;

            if (is_safe_nop(prev_m, next_m)) {
                program[i].alive = 0;
                nop_count++;
            }
        }
    }
}
void refactoring(FILE *fp, FILE *nfp)
{
    load_all_code(fp);
    optimize_nop();
    emit_all(nfp);
}

