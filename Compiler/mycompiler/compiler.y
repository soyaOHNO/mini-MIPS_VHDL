%{
    #include <stdio.h>
    #include "compiler.tab.h"
	#include "ast.h"
    extern int yylex();
    extern int yyerror(const char *);
	extern Node *top;
%}

%union{
	struct node *np;
    int num;
	char* str;
}

%token DEFINE FUNC FUNCCALL ARRAY WHILE FOR IF ELSE BREAK SEMIC L_BRACKET R_BRACKET L_PARAN R_PARAN L_BRACE R_BRACE ASSIGN ADD SUB MUL DIV MOD INC DEC EQ LT GT EL EG LAND LOR COMMA <str>IDENT <num>NUMBER

%type <np> program  declarations decl_statement decl_function func_call arguments decl_argument_list data_arguments data_argument_list decl_argument statements statement assignment_stmt cre_op_stmt expression term factor var loop_stmt cond_stmt conditions condition_and condition ary_num idents index value for_cond for_assi
%type <num> add_op mul_op cond_op cre_op

%%

program
: decl_function program {top = build_node2(FUNCTIONS_AST, $1, $2);}
| decl_function		      {top = build_node1(FUNCTIONS_AST, $1);}

decl_function
: FUNC IDENT L_PARAN arguments R_PARAN L_BRACE declarations statements R_BRACE
{
	$$ = build_node4(DECL_FUNCTION_AST, build_ident_node(FUNC_IDENT_AST, $2), build_node1(FUNC_ARG_AST, $4), build_node1(FUNC_DECL_AST, $7), build_node1(FUNC_STAT_AST, $8));
}
arguments
: decl_argument_list
| /* empty */        {$$ = NULL;}

decl_argument_list
: decl_argument COMMA decl_argument_list {$$ = build_node2(ARGUMENTS_AST, $1, $3);}
| decl_argument                          {$$ = build_node1(ARGUMENTS_AST, $1);}

decl_argument
: DEFINE IDENT {$$ = build_ident_node(IDENT_AST, $2);}
| ARRAY IDENT index {$$ = build_node2(ARG_ARRAY_AST, build_ident_node(IDENT_AST, $2), $3);}

declarations
: decl_statement declarations {$$ = build_node2(DECLARATIONS_AST, $1, $2);}
| decl_statement              {$$ = build_node1(DECLARATIONS_AST, $1);}

decl_statement
: DEFINE idents SEMIC     {$$ = build_node1(DEFINE_AST, $2);}
| ARRAY IDENT index SEMIC {$$ = build_node2(ARRAY_AST, build_ident_node(IDENT_AST, $2), $3);}

idents
: IDENT COMMA idents {$$ = build_node2(IDENTS_AST, build_ident_node(IDENT_AST, $1), $3);}
| IDENT              {$$ = build_ident_node(IDENT_AST, $1);}

index
: L_BRACKET ary_num R_BRACKET index {$$ = build_node2(INDEX_AST, $2, $4);}
| L_BRACKET ary_num R_BRACKET       {$$ = build_node1(INDEX_AST, $2);}

ary_num
: expression
| /* empty */ {$$ = NULL;}

statements
: statement statements {$$ = build_node2(STATEMENTS_AST, $1, $2);}
| statement

statement
: assignment_stmt SEMIC {$$ = build_node1(STATEMENT_AST, $1);}
| BREAK SEMIC           {$$ = build_node0(BREAK_AST);}
| loop_stmt             {$$ = build_node1(STATEMENT_AST, $1);}
| cond_stmt             {$$ = build_node1(STATEMENT_AST, $1);}
| func_call             {$$ = build_node1(STATEMENT_AST, $1);}

func_call
: FUNCCALL IDENT L_PARAN data_arguments R_PARAN SEMIC {$$ = build_node2(FUNC_CALL_AST, build_ident_node(IDENT_AST, $2), $4);}

data_arguments
: data_argument_list
| /* empty */                        {$$ = NULL;}

data_argument_list
: expression COMMA data_argument_list {$$ = build_node2(DATA_ARGUMENTS_AST, $1, $3);}
| expression                          {$$ = build_node1(DATA_ARGUMENTS_AST, $1);}

assignment_stmt
: IDENT ASSIGN expression       {$$ = build_node2(ASSIGNMENT_IDENT_AST, build_ident_node(IDENT_AST, $1), $3);}
| IDENT index ASSIGN expression {$$ = build_node3(ASSIGNMENT_ARRAY_AST, build_ident_node(IDENT_AST, $1), $2, $4);}
| cre_op_stmt

expression
: expression add_op term
    {
        if($2 == OP_ADD){
			$$ = build_node2(ADD_AST, $1, $3);
		} else {
			$$ = build_node2(SUB_AST, $1, $3);
		}
	}
| term

term
: term mul_op factor
	{
		if($2 == OP_MUL){
			$$ = build_node2(MUL_AST, $1, $3);
		} else if($2 == OP_DIV){
			$$ = build_node2(DIV_AST, $1, $3);
		} else {
			$$ = build_node2(MOD_AST, $1, $3);
		}
	}
| factor

cre_op_stmt
: var cre_op
    {
		if($2 == OP_INC){
			$$ = build_node1(POS_INC_AST, $1);
		} else {
			$$ = build_node1(POS_DEC_AST, $1);
		}
	}
| cre_op var
    {
		if($1 == OP_INC){
			$$ = build_node1(PRE_INC_AST, $2);
		} else {
			$$ = build_node1(PRE_DEC_AST, $2);
		}
	}

factor
: value
| var cre_op
    {
		if($2 == OP_INC){
			$$ = build_node1(POS_INC_AST, $1);
		} else {
			$$ = build_node1(POS_DEC_AST, $1);
		}
	}
| cre_op var
    {
		if($1 == OP_INC){
			$$ = build_node1(PRE_INC_AST, $2);
		} else {
			$$ = build_node1(PRE_DEC_AST, $2);
		}
	}
| L_PARAN expression R_PARAN {$$ = build_node1(EXPRESSION_AST, $2);}

add_op
: ADD {$$ = OP_ADD;}
| SUB {$$ = OP_SUB;}

mul_op
: MUL {$$ = OP_MUL;}
| DIV {$$ = OP_DIV;}
| MOD {$$ = OP_MOD;}

cre_op
: INC {$$ = OP_INC;}
| DEC {$$ = OP_DEC;}

value
: var
| NUMBER {$$ = build_num_node(NUMBER_AST, $1);}

var
: IDENT       {$$ = build_ident_node(IDENT_AST, $1);}
| IDENT index {$$ = build_node2(ARRAY_AST, build_ident_node(IDENT_AST, $1), $2);}

loop_stmt
: WHILE L_PARAN conditions R_PARAN L_BRACE statements R_BRACE {$$ = build_node2(WHILE_LOOP_STMT_AST, $3, $6);}
| WHILE L_PARAN conditions R_PARAN statement {$$ = build_node2(WHILE_LOOP_STMT_AST, $3, $5);}
| WHILE L_PARAN conditions R_PARAN SEMIC {$$ = build_node1(WHILE_LOOP_STMT_AST, $3);}
| FOR L_PARAN for_assi SEMIC for_cond SEMIC for_assi R_PARAN L_BRACE statements R_BRACE {$$ = build_node4(FOR_LOOP_STMT_AST, build_node1(FOR_INIT, $3), build_node1(FOR_COND, $5), build_node1(FOR_UPDA, $7), $10);}

cond_stmt
: IF L_PARAN conditions R_PARAN L_BRACE statements R_BRACE {$$ = build_node2(COND_STMT_AST, $3, build_node1(STATEMENTS_AST, $6));}
| IF L_PARAN conditions R_PARAN statement {$$ = build_node2(COND_STMT_AST, $3, build_node1(STATEMENT_AST, $5));}
| IF L_PARAN conditions R_PARAN L_BRACE statements R_BRACE ELSE L_BRACE statements R_BRACE {$$ = build_node3(COND_STMT_AST, $3, build_node1(STATEMENTS_AST, $6), build_node1(STATEMENTS_AST, $10));}
| IF L_PARAN conditions R_PARAN L_BRACE statements R_BRACE ELSE cond_stmt {$$ = build_node3(COND_STMT_AST, $3, build_node1(STATEMENTS_AST, $6), $9);}

for_cond
: conditions
| /* empty */ {$$ = NULL;}

for_assi
: assignment_stmt
| /* empty */ {$$ = NULL;}

conditions
: condition_and LOR conditions {$$ = build_node2(LOR_AST, $1, $3);}
| condition_and 

condition_and
: condition LAND condition_and {$$ = build_node2(LAND_AST, $1, $3);}
| condition

condition
: expression cond_op expression
		{
			if($2 == OP_EQ){
				$$ = build_node2(EQ_AST, $1, $3);
			} else if($2 == OP_LT){
				$$ = build_node2(LT_AST, $1, $3);
			} else if($2 == OP_GT){
				$$ = build_node2(GT_AST, $1, $3);
			} else if($2 == OP_EL){
				$$ = build_node2(EL_AST, $1, $3);
			} else {
				$$ = build_node2(EG_AST, $1, $3);
			}
		}
| expression {$$ = build_node1(EXPRESSION_AST, $1);}

cond_op
: EQ {$$ = OP_EQ;}
| LT {$$ = OP_LT;}
| GT {$$ = OP_GT;}
| EL {$$ = OP_EL;}
| EG {$$ = OP_EG;}

%%

int yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}