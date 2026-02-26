#define _GNU_SOURCE
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
extern int yyparse();
// プリント用
extern char *node_types[];

// ノードタイプ
typedef enum{
	IDENT_AST=0,
	NUMBER_AST,
	EQ_AST,
	LT_AST,
	GT_AST,
	EL_AST,
	EG_AST,
	OP_EQ,
	OP_LT,
	OP_GT,
	OP_EL,
	OP_EG,
	ADD_AST,
	SUB_AST,
	MUL_AST,
	DIV_AST,
	MOD_AST,
	INC_AST,
	DEC_AST,
	OP_ADD,
	OP_SUB,
	OP_MUL,
	OP_DIV,
	OP_MOD,
	OP_INC,
	OP_DEC,
	COND_OP_AST,
	CONDITION_AST,
	COND_STMT_AST,
	WHILE_LOOP_STMT_AST,
	FOR_LOOP_STMT_AST,
	FOR_INIT,
	FOR_COND,
	FOR_UPDA,
	VAR_AST,
	MUL_OP_AST,
	ADD_OP_AST,
	TERM_AST,
	EXPRESSION_AST,
	ASSIGNMENT_STMT_AST,
	ASSIGNMENT_IDENT_AST,
	ASSIGNMENT_ARRAY_AST,
	IDENTS_AST,
	ARY_NUM_AST,
	DECL_STATEMENT_AST,
	DECLARATIONS_AST,
	STATEMENTS_AST,
	STATEMENT_AST,
	BREAK_AST,
	POS_DEC_AST,
	POS_INC_AST,
	PRE_DEC_AST,
	PRE_INC_AST,
	DEFINE_AST,
	ARRAY_AST,
	DATA_ARGUMENT_AST,
	DATA_ARGUMENTS_AST,
	ARG_ARRAY_AST,
	ARGUMENTS_AST,
	FUNC_CALL_AST,
	FUNC_ARG_AST,
	FUNC_IDENT_AST,
	FUNC_DECL_AST,
	FUNC_STAT_AST,
	DECL_FUNCTION_AST,
	FUNCTIONS_AST,
	PROGRAM_AST,
	INDEX_AST,
	LOR_AST,
	LAND_AST,
} NType;
// 抽象構文木のノードのデータ構造
typedef struct node{
	NType type;
	struct node *child;
	int ivalue;
	char *variable;
	struct node *brother;
} Node;


// プロトタイプ宣言
void print_node_type(int node_type);
// 抽象構文木のノードの生成
Node *build_node0(NType t);
Node *build_num_node(NType t, int n);
Node *build_ident_node(NType t, char *s);
Node *build_node1(NType t, Node *p1);
Node *build_node2(NType t, Node *p1, Node *p2);
Node *build_node3(NType t, Node *p1, Node *p2, Node *p3);
Node *build_node4(NType t, Node *p1, Node *p2, Node *p3, Node *p4);
