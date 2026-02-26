#include "ast.h"
#define MAXBUF 31
extern int yyerror();
extern void gen_code(FILE *fp, Node *n);

void print_node_type(int node_type) {
	printf("Node type: %s\n", node_types[node_type]);
}

// プリント用
char *node_types[] = {
	"IDENT_AST",
	"NUMBER_AST",
	"EQ_AST",
	"LT_AST",
	"GT_AST",
	"EL_AST",
	"EG_AST",
	"OP_EQ",
	"OP_LT",
	"OP_GT",
	"OP_EL",
	"OP_EG",
	"ADD_AST",
	"SUB_AST",
	"MUL_AST",
	"DIV_AST",
	"MOD_AST",
	"INC_AST",
	"DEC_AST",
	"OP_ADD",
	"OP_SUB",
	"OP_MUL",
	"OP_DIV",
	"OP_MOD",
	"OP_INC",
	"OP_DEC",
	"COND_OP_AST",
	"CONDITION_AST",
	"COND_STMT_AST",
	"WHILE_LOOP_STMT_AST",
	"FOR_LOOP_STMT_AST",
	"FOR_INIT",
	"FOR_COND",
	"FOR_UPDA",
	"VAR_AST",
	"MUL_OP_AST",
	"ADD_OP_AST",
	"TERM_AST",
	"EXPRESSION_AST",
	"ASSIGNMENT_STMT_AST",
	"ASSIGNMENT_IDENT_AST",
	"ASSIGNMENT_ARRAY_AST",
	"IDENTS_AST",
	"ARY_NUM_AST",
	"DECL_STATEMENT_AST",
	"DECLARATIONS_AST",
	"STATEMENTS_AST",
	"STATEMENT_AST",
	"BREAK_AST",
	"POS_DEC_AST",
	"POS_INC_AST",
	"PRE_DEC_AST",
	"PRE_INC_AST",
	"DEFINE_AST",
	"ARRAY_AST",
	"DATA_ARGUMENT_AST",
	"DATA_ARGUMENTS_AST",
	"ARG_ARRAY_AST",
	"ARGUMENTS_AST",
	"FUNC_CALL_AST",
	"FUNC_ARG_AST",
	"FUNC_IDENT_AST",
	"FUNC_DECL_AST",
	"FUNC_STAT_AST",
	"DECL_FUNCTION_AST",
	"FUNCTIONS_AST",
	"PROGRAM_AST",
	"INDEX_AST",
	"LOR_AST",
	"LAND_AST",
};

Node *top; // 抽象構文木のルートノード保存用

Node *build_node0(NType t) {
	Node *p;
	p = (Node *)malloc(sizeof(Node));
	if (p == NULL) {
		yyerror("out of memory");
	}
	p->type = t;
	p->child = NULL;
	return p;
}
Node *build_num_node(NType t, int n){
	Node *p;
	p = (Node *)malloc(sizeof(Node));
	if(p == NULL){
		yyerror("out of memory");
	}
	p->type = t;
	p->ivalue = n;
	p->child = NULL;
	p->brother = NULL;
	return p;
}
Node *build_ident_node(NType t, char *s) {
	Node *p;
	p = (Node *)malloc(sizeof(Node));
	if (p == NULL) {
		yyerror("out of memory");
	}
	p->type = t;
	p->variable = (char *)malloc(sizeof(char) * MAXBUF);
	if (p->variable == NULL) {
		yyerror("out of memory");
	}
	strncpy(p->variable, s, MAXBUF);
	p->child = NULL;
	p->brother = NULL;
	return p;
}
Node *build_node1(NType t, Node *p1) {
	Node *p;
	p = (Node *)malloc(sizeof(Node));
	if (p == NULL) {
		yyerror("out of memory");
	}
	p->type = t;
	p->child = p1;
	return p;
}
Node *build_node2(NType t, Node *p1, Node *p2) {
	Node *p;
	p = (Node *)malloc(sizeof(Node));
	if (p == NULL) {
		yyerror("out of memory");
	}
	p->type = t;
	p->child = p1;
	p->child->brother = p2;
	return p;
}
Node *build_node3(NType t, Node *p1, Node *p2, Node *p3) {
	Node *p;
	p = (Node *)malloc(sizeof(Node));
	if (p == NULL) {
		yyerror("out of memory");
	}
	p->type = t;
	p->child = p1;
	p->child->brother = p2;
	p->child->brother->brother = p3;
	return p;
}
Node *build_node4(NType t, Node *p1, Node *p2, Node *p3, Node *p4) {
	Node *p;
	p = (Node *)malloc(sizeof(Node));
	if (p == NULL) {
		yyerror("out of memory");
	}
	p->type = t;
	p->child = p1;
	p->child->brother = p2;
	p->child->brother->brother = p3;
	p->child->brother->brother->brother = p4;
	return p;
}

int print_tree(Node *n, int num) {
	printf("\"%s_%d\": {", node_types[n->type], num++);
	if (n->child != NULL) {
		num = print_tree(n->child, num);
	}
	printf("}");
	if (n->brother != NULL) {
		printf(",");
		num = print_tree(n->brother, num);
	}
	return num;
}

void print_tree_in_json(Node *n) {
	if (n != NULL) {
		int num = 0;
		printf("{");
		print_tree(n, num);
		printf("}");
	}
}


/* ast.c の末尾付近にある main 関数を以下に差し替え */

// 各モジュールのエントリポイント（各ファイルの main をリネームして宣言）
extern void refactoring(FILE *fp, FILE *nfp); // optimization.c 内
extern void assemble(FILE *fp, FILE *nfp);    // assembler.c 内

int main (int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    // 入力ファイルを yylex が読み込めるように設定
    extern FILE *yyin;
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Fopen input file");
        return 1;
    }

    // --- 1. 構文解析とコード生成 (a.s) ---
    FILE *fp_as = fopen("a.s", "w");
    if (yyparse()) {
        fprintf(stderr, "Syntax Error!\n");
        return 1;
    }
    printf("[1/3] AST generation completed. Generating a.s...\n");
    gen_code(fp_as, top);
    fclose(fp_as);

    // --- 2. 最適化 (a_opt.s) ---
    printf("[2/3] Optimizing... Generating a_opt.s...\n");
    FILE *fp_s = fopen("a.s", "r");
    FILE *fp_opt = fopen("a_opt.s", "w");
    if (fp_s && fp_opt) {
        refactoring(fp_s, fp_opt); // optimization.c の処理
        fclose(fp_s);
        fclose(fp_opt);
    }

    // --- 3. アセンブル (InstructionMemory.mif) ---
    printf("[3/3] Assembling... Generating InstructionMemory.mif...\n");
    FILE *fp_opt_r = fopen("a_opt.s", "r");
    FILE *fp_mif = fopen("InstructionMemory.mif", "w"); // 要求に合わせて名前変更
    if (fp_opt_r && fp_mif) {
        assemble(fp_opt_r, fp_mif); // assembler.c の処理
        fclose(fp_opt_r);
        fclose(fp_mif);
    }

    printf("\nCompilation finished successfully.\n");
    printf("Outputs: a.s, a_opt.s, InstructionMemory.mif\n");

    return 0;
}
