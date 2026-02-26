#include "mips_common.h"

static Label labels[MAX_LINES];
static int label_count = 0;

static Instruction Instructions[MAX_LINES];
static int code_count = 0;
// printf("\t%s : %s; -- %s\n", Instructions[i].addr, Instructions[i].inst, Instructions[i].dst);

// 2進数文字列を unsigned int に変換する補助関数
unsigned int bin2int(const char *bin_str) {
    if (!bin_str || strcmp(bin_str, "invalid") == 0 || strcmp(bin_str, "UNKNOWN") == 0) return 0;
    return (unsigned int)strtol(bin_str, NULL, 2);
}

// ラベル名からアドレスを検索する補助関数
int get_label_addr(const char *name) {
    if (!name) return 0;
    for (int i = 0; i < label_count; i++) {
        if (strcmp(labels[i].name, name) == 0) {
            return labels[i].addr;
        }
    }
    fprintf(stderr, "Warning: Label '%s' not found.\n", name);
    return 0;
}
void assemble(FILE *fp, FILE *nfp)
{
    // 1. ファイルから全行を読み込み、MIPS構造体の配列にパースする
    load_all_code(fp);

    int pc = 0; // プログラムカウンタ（ワード単位なら 0, 1, 2... バイト単位なら 0, 4, 8...）

    // 【パス1】 ラベルの抽出とアドレス計算
    for (int i = 0; i < total_lines; i++) {
        if (program[i].alive == 0) continue;

        // コメント（'#'以降）を無視して処理するためのバッファ
        char temp_raw[MAX_LEN];
        strcpy(temp_raw, program[i].m.raw);
        char *hash = strchr(temp_raw, '#');
        if (hash != NULL) {
            *hash = '\0'; // '#'以降を文字列の終端にして消去
        }

        // ':' が含まれているかチェック
        char *colon = strchr(temp_raw, ':');
        if (colon != NULL) {
            char label_name[MAX_LABEL_LEN];
            int len = colon - temp_raw;
            int k = 0;
            
            // ':' の前にある空白やタブを飛ばしてラベル名だけを抽出
            for (int j = 0; j < len; j++) {
                if (temp_raw[j] != ' ' && temp_raw[j] != '\t') {
                    label_name[k++] = temp_raw[j];
                }
            }
            label_name[k] = '\0';

            // labels 配列に登録
            if (k > 0) {
                strcpy(labels[label_count].name, label_name);
                labels[label_count].addr = pc;
                label_count++;
            }
        }

        // 有効な命令であればPCを進める（ラベルのみの行や .text などのディレクティブは進めない）
        if (program[i].m.ope != OPT_UNKNOWN && !is_label_etc(program[i].m.ope)) {
            pc += 4; // MIPS命令は4バイトなので、PCは4ずつ増加します
        }
    }
    // デバッグ用出力
    printf("--- Label Table ---\n");
    for (int i = 0; i < label_count; i++) {
        printf("%s : %08X\n", labels[i].name, labels[i].addr);
    }

    // 【パス2】 機械語のエンコードとファイル出力
    pc = 0;
    for (int i = 0; i < total_lines; i++) {
        if (program[i].alive == 0) continue;
        
        struct MIPS *m = &program[i].m;
        if (m->ope == OPT_UNKNOWN || is_label_etc(m->ope)) continue;

        unsigned int machine_code = 0;
        unsigned int op = bin2int(oname_to_bit(m->ope));

        if (is_r_type(m->ope)) {
            unsigned int rs = bin2int(rname_to_bit(m->rs));
            unsigned int rt = bin2int(rname_to_bit(m->rt));
            unsigned int rd = bin2int(rname_to_bit(m->rd));
            unsigned int funct = bin2int(oname_to_funct(m->ope));
            unsigned int shamt = 0;

            // SLL, SRL, SRA などのシフト命令は rs が 0 で、即値が shamt に入る
            if (m->ope == OPT_SLL || m->ope == OPT_SRL || m->ope == OPT_SRA) {
                rs = 0;
                shamt = m->imm & 0x1F; // 5bit
            }
            // JR, JALR, MFHI, MFLO など、オペランドが少ない命令の調整が必要な場合はここで rt や rd を 0 にします

            machine_code = (op << 26) | (rs << 21) | (rt << 16) | (rd << 11) | (shamt << 6) | funct;
        } 
        else if (is_i_type(m->ope) || is_mem_type(m->ope)) {
            unsigned int rs = bin2int(rname_to_bit(m->rs));
            unsigned int rt = bin2int(rname_to_bit(m->rt));
            unsigned int imm = m->imm & 0xFFFF; // 16bitでマスク（負の数対応）
            
            machine_code = (op << 26) | (rs << 21) | (rt << 16) | imm;
        }
        else if (is_branch_or_jump(m->ope)) {
            if (m->ope == OPT_BEQ || m->ope == OPT_BNE) {
                // I-type Branch
                unsigned int rs = bin2int(rname_to_bit(m->rs));
                unsigned int rt = bin2int(rname_to_bit(m->rt));
                int target_addr = get_label_addr(m->label);
                
                // MIPSの相対アドレス計算: (ターゲットアドレス - (現在のPC + 4)) / 4
                int offset = (target_addr - (pc + 4)) / 4;
                unsigned int imm = offset & 0xFFFF;
                
                machine_code = (op << 26) | (rs << 21) | (rt << 16) | imm;
            } 
            else if (m->ope == OPT_J || m->ope == OPT_JAL) {
                // J-type Jump
                int target_addr = get_label_addr(m->label);
                
                // MIPSの絶対アドレス計算: ターゲットアドレス / 4
                unsigned int target = (target_addr / 4) & 0x3FFFFFF; // 26bit
                machine_code = (op << 26) | target;
            }
        }

        // Instructions配列に保存
        sprintf(Instructions[code_count].addr, "%03X", pc / 4); // アドレスをワード単位(pc/4)の16進数で保存
        sprintf(Instructions[code_count].inst, "%08X", machine_code); // 機械語を16進数で保存
        Instructions[code_count].dst = strdup(m->raw); // 元のアセンブリ文字列を保存
        
        code_count++;
        pc += 4; // PCを進める
    }

    // 【出力フェーズ】 Instructions配列の中身をファイル(および画面)に出力
    // MIF形式などに合わせてヘッダーが必要な場合はここで出力します
    fprintf(nfp, "WIDTH=32;\nDEPTH=1024;\nADDRESS_RADIX=HEX;\nDATA_RADIX=HEX;\n\nCONTENT BEGIN\n");

    for (int i = 0; i < code_count; i++) {
        // ファイルへの書き込み
        fprintf(nfp, "\t%s : %s; -- %s\n", Instructions[i].addr, Instructions[i].inst, Instructions[i].dst);
        
        // 画面（標準出力）にも同じものを表示して確認
        printf("\t%s : %s; -- %s\n", Instructions[i].addr, Instructions[i].inst, Instructions[i].dst);
    }

    // MIF形式のフッターなどが必要な場合はここで出力します
    fprintf(nfp, "\t[%03X..3FF] : 00000000;\n", code_count);
    fprintf(nfp, "END;\n");
}
