#include "ast.h"

int if_flag = 0;
int while_loop_flag = 0;
int for_loop_flag = 0;

typedef struct index {
    int size;
    struct index *next;
} Index;

void index_append(Index **head, int size) {
    Index *node = malloc(sizeof(Index));
    node->size = size;
    node->next = NULL;
    if (*head == NULL) {
        *head = node;
        return;
    }
    Index *cur = *head;
    while (cur->next) {
        cur = cur->next;
    }
    cur->next = node;
}

typedef struct SymbolTable {
    char *name;
    int offset;
    int is_arg;
    struct index *index_size;
    struct SymbolTable *next;
} SymbolTable;

SymbolTable *STinit(char *n, int is_arg, Index *size, int offset_p)
{
    SymbolTable *st = malloc(sizeof(SymbolTable));
    st->name = strdup(n);
    st->offset = offset_p;
    st->is_arg = is_arg;
    st->index_size = size;
    st->next = NULL;
    return st;
}
int STpush(FILE *fp, char *n, Index *size, int offset_p, int is_arg, SymbolTable **STtop)
{
    SymbolTable *new;
    new = STinit(n, is_arg, size, offset_p);
    if (new == NULL) return -1;
    new->next = *STtop;
    *STtop = new;
    fprintf(fp, "# Declare variable %s, offset %d\n", new->name, new->offset);
    return 1;
}
SymbolTable *lookup(SymbolTable *STtop, const char *name) {
    SymbolTable *cur = STtop;
    while (cur) {
        if (strcmp(cur->name, name) == 0)
            return cur;
        cur = cur->next;
    }
    return NULL;
}
int getOffset(SymbolTable *STtop, char *n)
{
    if (STtop == NULL) return -1;
    if (strcmp(n, STtop->name) == 0) return STtop->offset;
    return getOffset(STtop->next, n);
}

char *Reg_name[] = {"$v0", "$v1", "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7", "$t8", "$t9"};
typedef struct Register{
    int alive;
} Register;
Register Reg[20];
void REGinit()
{
    Reg[0].alive = 1;
    Reg[1].alive = 1;
    for (int i=2; i < 20; i++) Reg[i].alive = 0;
}
int Ruse()
{
    for (int i=2; i < 20; i++) {
        if (Reg[i].alive == 0) {
            Reg[i].alive = 1;
            return i;
        }
    }
    fprintf(stderr, "Register exhausted\n");
    exit(0);
}
void Rfree(int a)
{
    if (a < 2) return;
    Reg[a].alive = 0;
}
char *printReg(int a)
{
    if (a < 0) exit(0);
    return Reg_name[a];
}


char *label_stack[16];
int label_sp = 0;
void stmt_code(FILE *fp, Node *n, SymbolTable **STtop);
void expr_code(FILE *fp, Node *n, SymbolTable **STtop);

void index_code(FILE *fp, Node *n, SymbolTable **STtop)
{
    Node *ident = n->child;
    Node *idx = ident->brother;
    SymbolTable *sym = lookup(*STtop, ident->variable);
    if (!sym) {
        fprintf(stderr, "undefined variable: %s\n", ident->variable);
        exit(1);
    }
    Index *dim = sym->index_size;
    int offsum = Ruse();
    int value = Ruse();
    fprintf(fp, "\taddi\t\t%s, 0\n", printReg(offsum));
    while (idx && idx->type == INDEX_AST && dim) {
        expr_code(fp, idx->child, STtop);
        unsigned int upper = (dim->size >> 16) & 0xffff, lower = dim->size & 0xffff;
        fprintf(fp, "\tlui\t\t%s, %d\n", printReg(value), upper);
        fprintf(fp, "\tori\t\t%s, %s, %d\n", printReg(value), printReg(value), lower);
        fprintf(fp, "\tmult\t%s, %s\n\tmflo\t%s\n", printReg(offsum), printReg(value), printReg(offsum));
        fprintf(fp, "\tadd\t\t%s, %s, $v0\n", printReg(offsum), printReg(offsum));
        idx = idx->child->brother;
        dim = dim->next;
    }
    Rfree(value);
    int offset = sym->offset;
    if (sym->is_arg) {
        fprintf(fp, "\tlw\t\t$v0, %d($fp)\n\tnop\n", offset);
    } else {
        fprintf(fp, "\taddi\t$v0, $fp, %d\n", -offset);
    }
    fprintf(fp, "\tsll\t\t%s, %s, 2\n", printReg(offsum), printReg(offsum));
    fprintf(fp, "\tadd\t\t$v0, $v0, %s\n", printReg(offsum));
    Rfree(offsum);
}

void expr_code(FILE *fp, Node *n, SymbolTable **STtop)
{
    if (n == NULL) return;
    int offset, left;
    if (n->type == EXPRESSION_AST) expr_code(fp, n->child, STtop);
    else if (n->type == IDENT_AST) {
        SymbolTable *sym = lookup(*STtop, n->variable);
        if (sym->index_size != NULL && !sym->is_arg) {
            fprintf(fp, "\taddi\t$v0, $fp, %d\n", -sym->offset);
        }
        else if (sym->is_arg) {
            fprintf(fp, "\tlw\t\t$v0, %d($fp)\n\tnop\n", sym->offset);
        }
        else {
            fprintf(fp, "\tlw\t\t$v0, %d($fp)\n\tnop\n", -sym->offset);
        }
    }
    else if (n->type == ARRAY_AST) {
        left = Ruse();
        index_code(fp, n, STtop);
        fprintf(fp, "\tlw\t\t$v0, 0($v0)\n\tnop\n");
        Rfree(left);
    }
    else if (n->type == NUMBER_AST) {
        unsigned int upper = (n->ivalue >> 16) & 0xffff, lower = n->ivalue & 0xffff;
        fprintf(fp, "\tlui\t\t$v0, %d\n", upper);
        fprintf(fp, "\tori\t\t$v0, $v0, %d\n", lower);
    }
    else if (n->type == ADD_AST){
        expr_code(fp, n->child, STtop);
        fprintf(fp, "\tsw\t\t$v0, -4($sp)\n\taddi\t$sp, $sp, -4\n");
        expr_code(fp, n->child->brother, STtop);
        left = Ruse();
        fprintf(fp, "\tlw\t\t%s, 0($sp)\n\taddi\t$sp, $sp, 4\n", printReg(left));
        fprintf(fp, "\tadd\t\t$v0, %s, $v0\t# ADD_AST\n", printReg(left));
        Rfree(left);
    }
    else if (n->type == SUB_AST){
        expr_code(fp, n->child, STtop);
        fprintf(fp, "\tsw\t\t$v0, -4($sp)\n\taddi\t$sp, $sp, -4\n");
        expr_code(fp, n->child->brother, STtop);
        left = Ruse();
        fprintf(fp, "\tlw\t\t%s, 0($sp)\n\taddi\t$sp, $sp, 4\n", printReg(left));
        fprintf(fp, "\tsub\t\t$v0, %s, $v0\t# SUB_AST\n", printReg(left));
        Rfree(left);
    }
    else if (n->type == MUL_AST){
        expr_code(fp, n->child, STtop);
        fprintf(fp, "\tsw\t\t$v0, -4($sp)\n\taddi\t$sp, $sp, -4\n");
        expr_code(fp, n->child->brother, STtop);
        left = Ruse();
        fprintf(fp, "\tlw\t\t%s, 0($sp)\n\taddi\t$sp, $sp, 4\n", printReg(left));
        fprintf(fp, "\tmult\t%s, $v0\n", printReg(left));
        fprintf(fp, "\tmflo\t$v0\t# MUL_AST\n");
        Rfree(left);
    }
    else if (n->type == DIV_AST){
        expr_code(fp, n->child, STtop);
        fprintf(fp, "\tsw\t\t$v0, -4($sp)\n\taddi\t$sp, $sp, -4\n");
        expr_code(fp, n->child->brother, STtop);
        left = Ruse();
        fprintf(fp, "\tlw\t\t%s, 0($sp)\n\taddi\t$sp, $sp, 4\n", printReg(left));
        fprintf(fp, "\tdiv\t\t%s, $v0\n", printReg(left));
        fprintf(fp, "\tmflo\t$v0\t# DIV_AST\n");
        Rfree(left);
    }
    else if (n->type == MOD_AST){
        expr_code(fp, n->child, STtop);
        fprintf(fp, "\tsw\t\t$v0, -4($sp)\n\taddi\t$sp, $sp, -4\n");
        expr_code(fp, n->child->brother, STtop);
        left = Ruse();
        fprintf(fp, "\tlw\t\t%s, 0($sp)\n\taddi\t$sp, $sp, 4\n", printReg(left));
        fprintf(fp, "\tdiv\t\t%s, $v0\n", printReg(left));
        fprintf(fp, "\tmfhi\t$v0\t# MOD_AST\n");
        Rfree(left);
    }
    else if (n->type == POS_INC_AST || n->type == PRE_INC_AST || n->type == POS_DEC_AST || n->type == PRE_DEC_AST){
        Node *target = n->child;
        left = Ruse();
        if (target->type == IDENT_AST) {
            SymbolTable *sym = lookup(*STtop, target->variable);
            offset = sym->offset;
            if (offset < 0) {
                 fprintf(stderr, "undefined variable: %s\n", target->variable);
                 exit(1);
            }
            if (!sym->is_arg) offset = -offset;
            fprintf(fp, "\tlw\t\t%s, %d($fp)\n\tnop\n", printReg(left), offset);
            if (n->type == POS_INC_AST) {
                fprintf(fp, "\taddi\t$v0, %s, 0\n", printReg(left));
                fprintf(fp, "\taddi\t%s, %s, 1\n", printReg(left), printReg(left));
                fprintf(fp, "\tsw\t\t%s, %d($fp)\n\tnop\n", printReg(left), offset);
            } else if (n->type == PRE_INC_AST) {
                fprintf(fp, "\taddi\t%s, %s, 1\n", printReg(left), printReg(left));
                fprintf(fp, "\tsw\t\t%s, %d($fp)\n", printReg(left), offset);
                fprintf(fp, "\taddi\t$v0, %s, 0\n", printReg(left));
            } else if (n->type == POS_DEC_AST) {
                fprintf(fp, "\taddi\t$v0, %s, 0\n", printReg(left));
                fprintf(fp, "\taddi\t%s, %s, -1\n", printReg(left), printReg(left));
                fprintf(fp, "\tsw\t\t%s, %d($fp)\n\tnop\n", printReg(left), offset);
            } else if (n->type == PRE_DEC_AST) {
                fprintf(fp, "\taddi\t%s, %s, -1\n", printReg(left), printReg(left));
                fprintf(fp, "\tsw\t\t%s, %d($fp)\n", printReg(left), offset);
                fprintf(fp, "\taddi\t$v0, %s, 0\n", printReg(left));
            }
        }
        else if (target->type == ARRAY_AST) {
            index_code(fp, target, STtop);
            fprintf(fp, "\tlw\t\t%s, 0($v0)\n\tnop\t", printReg(left));
            if (n->type == POS_INC_AST) {
                fprintf(fp, "\taddi\t$v0, %s, 0\n", printReg(left));
                fprintf(fp, "\taddi\t%s, %s, 1\n", printReg(left), printReg(left));
                fprintf(fp, "\tsw\t\t%s, 0($v0)\n\tnop\n", printReg(left));
            } else if (n->type == PRE_INC_AST) {
                fprintf(fp, "\taddi\t%s, %s, 1\n", printReg(left), printReg(left));
                fprintf(fp, "\tsw\t\t%s, 0($v0)\n", printReg(left));
                fprintf(fp, "\taddi\t$v0, %s, 0\n", printReg(left));
            } else if (n->type == POS_DEC_AST) {
                fprintf(fp, "\taddi\t$v0, %s, 0\n", printReg(left));
                fprintf(fp, "\taddi\t%s, %s, -1\n", printReg(left), printReg(left));
                fprintf(fp, "\tsw\t\t%s, 0($v0)\n\tnop\n", printReg(left));
            } else if (n->type == PRE_DEC_AST) {
                fprintf(fp, "\taddi\t%s, %s, -1\n", printReg(left), printReg(left));
                fprintf(fp, "\tsw\t\t%s, 0($v0)\n", printReg(left));
                fprintf(fp, "\taddi\t$v0, %s, 0\n", printReg(left));
            }
        }
        Rfree(left);
    }
}

int assi_code(FILE *fp, Node *n, SymbolTable **STtop)
{
    int offset, left;
    if (n == NULL || n->child == NULL) return -1;
    if (n->type == ASSIGNMENT_STMT_AST) expr_code(fp, n->child, STtop);
    else if (n->type == ASSIGNMENT_IDENT_AST) {
        Node *ident = n->child;
        if (ident->brother == NULL) return -1;
        expr_code(fp, ident->brother, STtop);
        SymbolTable *sym = lookup(*STtop, ident->variable);
        offset = sym->offset;
        if (offset < 0) {
            fprintf(stderr, "undefined variable: %s\n", ident->variable);
            exit(1);
        }
        if (sym->is_arg) fprintf(fp, "\tsw\t\t$v0, %d($fp)\n\tnop\n", offset);
        else fprintf(fp, "\tsw\t\t$v0, %d($fp)\n\tnop\n", -offset);
    }
    else if (n->type == ASSIGNMENT_ARRAY_AST) {
        Node *expr = n->child->brother->brother;
        index_code(fp, n, STtop);
        fprintf(fp, "\tsw\t\t$v0, -4($sp)\n\taddi\t$sp, $sp, -4\n");
        expr_code(fp, expr, STtop);
        left = Ruse();
        fprintf(fp, "\tlw\t\t%s, 0($sp)\n\taddi\t$sp, $sp, 4\n", printReg(left));
        fprintf(fp, "\tsw\t\t$v0, 0(%s)\n\tnop\n", printReg(left));
        Rfree(left);
    }
    else if (n->type == POS_INC_AST || n->type == POS_DEC_AST || n->type == PRE_INC_AST || n->type == PRE_DEC_AST) {
        expr_code(fp, n, STtop);
    }
    return 0;
}


void cond_code(FILE *fp, Node *n, SymbolTable **STtop)
{
    int left;
    if (n->type == LOR_AST || n->type == LAND_AST) {
        cond_code(fp, n->child, STtop);
        fprintf(fp, "\tsw\t\t$v0, -4($sp)\n\taddi\t$sp, $sp, -4\n");
        cond_code(fp, n->child->brother, STtop);
        left = Ruse();
        fprintf(fp, "\tlw\t\t%s, 0($sp)\n\taddi\t$sp, $sp, 4\n", printReg(left));
        fprintf(fp, "\tsltu\t%s, $zero, %s\n", printReg(left), printReg(left));
        fprintf(fp, "\tsltu\t$v0, $zero, $v0\n");
        if (n->type == LOR_AST) {
            fprintf(fp, "\tor\t\t$v0, %s, $v0\n", printReg(left));
        }
        else if (n->type == LAND_AST) {
            fprintf(fp, "\tand\t\t$v0, %s, $v0\n", printReg(left));
        }
        Rfree(left);
    }
    else if (n->type == EXPRESSION_AST) {
        expr_code(fp, n->child, STtop);
        fprintf(fp, "\tsltu\t$v0, $zero, $v0\n");
    }
    else {
        expr_code(fp, n->child, STtop);
        fprintf(fp, "\tsw\t\t$v0, -4($sp)\n\taddi\t$sp, $sp, -4\n");
        expr_code(fp, n->child->brother, STtop);
        left = Ruse();
        fprintf(fp, "\tlw\t\t%s, 0($sp)\n\taddi\t$sp, $sp, 4\n", printReg(left));
        if (n->type == LT_AST) {
            fprintf(fp, "\tslt\t\t$v0, %s, $v0\n", printReg(left));
        }
        else if (n->type == GT_AST) {
            fprintf(fp, "\tslt\t\t$v0, $v0, %s\n", printReg(left));
        }
        else if (n->type == EL_AST) {
            fprintf(fp, "\tslt\t\t$v0, $v0, %s\n", printReg(left));
            fprintf(fp, "\txori\t$v0, $v0, 1\n");
        }
        else if (n->type == EG_AST) {
            fprintf(fp, "\tslt\t\t$v0, %s, $v0\n", printReg(left));
            fprintf(fp, "\txori\t$v0, $v0, 1\n");
        }
        else if (n->type == EQ_AST) {
            fprintf(fp, "\tsubu\t$v0, $v0, %s\n", printReg(left));
            fprintf(fp, "\tsltu\t$v0, $zero, $v0\n");
            fprintf(fp, "\txori\t$v0, $v0, 1\n");
        }
        Rfree(left);
    }
}


void while_code(FILE *fp, Node *n, SymbolTable **STtop)
{
    int while_loop_flag_now = while_loop_flag;
    char *new_label;
    while_loop_flag++;
    fprintf(fp, "_WHILE_%d:\n", while_loop_flag_now);
    asprintf(&new_label, "_WHILE_END_%d", while_loop_flag_now);
    label_stack[label_sp++] = new_label;
    if (n->child != NULL) {
        cond_code(fp, n->child, STtop);
        fprintf(fp, "\tbeq\t\t$v0, $zero, _WHILE_END_%d\n\tnop\n", while_loop_flag_now);
    }
    fprintf(fp, "# START while body\n");
    if (n->child->brother != NULL) stmt_code(fp, n->child->brother, STtop);
    fprintf(fp, "# END while body\n");
    fprintf(fp, "\tj\t\t_WHILE_%d\n\tnop\n", while_loop_flag_now);
    fprintf(fp, "_WHILE_END_%d:\n", while_loop_flag_now);
    label_sp--;
}

void for_code(FILE *fp, Node *n, SymbolTable **STtop)
{
    int for_loop_flag_now = for_loop_flag;
    char *new_label;
    for_loop_flag++;
    Node *init = n->child, *cond = init->brother, *upda = cond->brother, *body = upda->brother;
    asprintf(&new_label, "_FOR_END_%d", for_loop_flag_now);
    label_stack[label_sp++] = new_label;
    if (init && init->type == FOR_INIT && init->child != NULL) assi_code(fp, init->child, STtop);
    fprintf(fp, "_FOR_%d:\n", for_loop_flag_now);
    if (cond && cond->type == FOR_COND && cond->child != NULL) {
        cond_code(fp, cond->child, STtop);
        fprintf(fp, "\tbeq\t\t$v0, $zero, _FOR_END_%d\n\tnop\n", for_loop_flag_now);
    }
    fprintf(fp, "# START for body\n");
    if (body != NULL) stmt_code(fp, body, STtop);
    fprintf(fp, "# END for body\n");
    if (upda && upda->type == FOR_UPDA && upda->child != NULL) assi_code(fp, upda->child, STtop);
    fprintf(fp, "\tj\t\t_FOR_%d\n\tnop\n", for_loop_flag_now);
    fprintf(fp, "_FOR_END_%d:\n", for_loop_flag_now);
    label_sp--;
}

void if_code(FILE *fp, Node *n, int local_if_flag, int if_end, SymbolTable **STtop)
{
    fprintf(fp, "# START if_%d\n", local_if_flag);
    cond_code(fp, n->child, STtop);
    fprintf(fp, "\tbeq\t\t$v0, $zero, _IF_%d\n\tnop\n", local_if_flag);
    fprintf(fp, "# START if body\n");
    stmt_code(fp, n->child->brother, STtop);
    fprintf(fp, "# END if body\n");
    fprintf(fp, "\tj\t\t_IF_END_%d\n\tnop\n", if_end);
    fprintf(fp, "_IF_%d:\n", local_if_flag);
    if (n->child->brother->brother != NULL){
        if (n->child->brother->brother->type == COND_STMT_AST) {
            if_flag++;
            if_code(fp, n->child->brother->brother, if_flag, if_end, STtop);
        } else {
            fprintf(fp, "# START if body\n");
            stmt_code(fp, n->child->brother->brother, STtop);
            fprintf(fp, "# END if body\n");
            fprintf(fp, "\tj\t\t_IF_END_%d\n\tnop\n", if_end);
        }
    }
}


void init_code(FILE *fp)
{
    REGinit();
    fprintf(fp, "init:\n");
    fprintf(fp, "\taddi   $sp, $zero, 1024\n");
    fprintf(fp, "\taddi   $fp, $sp, 0\n");
    fprintf(fp, "\tstop_service =99\n\n");
    fprintf(fp, "\t.text #テキストセグメントの開始\n");
    fprintf(fp, "\tjal\t\tmain # jump to `main`\n");
    fprintf(fp, "\tnop #(delay slot)\n");
    fprintf(fp, "stop: # if syscall return\n");
    fprintf(fp, "\tj\t\tstop # infinite loop...\n");
    fprintf(fp, "\tnop #(delay slot)\n\n");
}
int decl_code(FILE *fp, Node *n, int offset_p, SymbolTable **STtop)
{
    if (!n || !n->child) return offset_p;
    if (n->child->type == DEFINE_AST) {
        Node *def = n->child;
        Index *indices = NULL;
        Node *idents = def->child;
        if (idents->type == IDENTS_AST) {
            while(idents && idents->type == IDENTS_AST) {
                offset_p += 4;
                STpush(fp, idents->child->variable, indices, offset_p, 0, STtop);
                idents = idents->child->brother;
            }
        }
        if (idents->type == IDENT_AST) {
            offset_p += 4;
            STpush(fp, idents->variable, indices, offset_p, 0, STtop);
        }
    }
    if (n->child->type == ARRAY_AST) {
        Node *ident = n->child->child;
        Node *idx = ident->brother;
        if (!ident || ident->type != IDENT_AST) {
            fprintf(stderr, "invalid array declaration\n");
            exit(1);
        }
        Index *indices = NULL;
        int index = 1;
        while (idx && idx->type == INDEX_AST) {
            if (!idx->child || idx->child->type != NUMBER_AST) {
                fprintf(stderr, "array size must be constant\n");
                exit(1);
            }
            index *= idx->child->ivalue;
            index_append(&indices, idx->child->ivalue);
            idx = idx->child->brother;
        }
        offset_p += 4 * index;
        STpush(fp, ident->variable, indices, offset_p, 0, STtop);
    }
    if (n->child->brother && n->child->brother->type == DECLARATIONS_AST) offset_p = decl_code(fp, n->child->brother, offset_p, STtop);
    return offset_p;
}
int arg_code(FILE *fp, Node *n, int offset_p, SymbolTable **STtop)
{
    if (!n) return offset_p;
    Node *arg = n->child;
    if (!arg) return offset_p;
    Index *indices = NULL;
    if (offset_p == 0) offset_p = 8;
    switch (arg->type) {
        case FUNC_IDENT_AST:
            break;
        case IDENT_AST:
            STpush(fp, arg->variable, indices, offset_p, 1, STtop);
            offset_p += 4;
            break;
        case ARG_ARRAY_AST:
            {
                Index *arg_array = malloc(sizeof(Index));
                arg_array->size = -1;
                arg_array->next = NULL;
                STpush(fp, arg->child->variable, arg_array, offset_p, 1, STtop);
                offset_p += 4;
            }
            break;
        default:
            fprintf(stderr, "Unknown argument AST type: %d\n", arg->type);
            break;
    }
    if (arg->brother) offset_p = arg_code(fp, arg->brother, offset_p, STtop);
    return offset_p;
}

int push_args(FILE *fp, Node *arg, SymbolTable **STtop) {
    if (arg == NULL) return 0;
    int count = push_args(fp, arg->child->brother, STtop);
    Node *expr = arg->child;
    if (expr->type == IDENT_AST) {
        SymbolTable *sym = lookup(*STtop, expr->variable);
        if (!sym) {
            fprintf(stderr, "undefined variable: %s\n", expr->variable);
            exit(1);
        }
        if (sym->is_arg) {
            fprintf(fp, "\tlw\t\t$v0, %d($fp)\n\tnop\n", sym->offset);
        }
        else if (sym->index_size != NULL) {
            fprintf(fp, "\taddi\t$v0, $fp, %d\n", -sym->offset);
        } else {
            expr_code(fp, expr, STtop);
        }
    } else {
        expr_code(fp, expr, STtop);
    }
    fprintf(fp, "\taddi\t$sp, $sp, -4\n");
    fprintf(fp, "\tsw\t\t$v0, 0($sp)\n\tnop\n");
    return count + 1;
}

void func_call(FILE *fp, Node *func_name, SymbolTable **STtop){
    Node *arg = func_name->brother;
    int arg_num = 0;
    if (arg != NULL && arg->type == DATA_ARGUMENTS_AST) {
        arg_num = push_args(fp, arg, STtop);
    }
    fprintf(fp, "\tjal\t\t%s\n\tnop\n", func_name->variable);
    if (arg_num > 0) fprintf(fp, "\taddi\t$sp, $sp, %d\n", arg_num * 4);
}

void stmt_code(FILE *fp, Node *stat, SymbolTable **STtop)
{
    if (stat == NULL) return;
    if (stat->type == STATEMENTS_AST) {
        stmt_code(fp, stat->child, STtop);
        return;
    }
    if (stat->type == STATEMENT_AST) {
        Node *s = stat->child;
        if (s->type == ASSIGNMENT_STMT_AST || s->type == ASSIGNMENT_IDENT_AST || s->type == ASSIGNMENT_ARRAY_AST) assi_code(fp, s, STtop);
        else if (s->type == WHILE_LOOP_STMT_AST) while_code(fp, s, STtop);
        else if (s->type == FOR_LOOP_STMT_AST) for_code(fp, s, STtop);
        else if (s->type == COND_STMT_AST) {
            int if_end = if_flag++;
            if_code(fp, s, if_flag, if_end, STtop);
            fprintf(fp, "_IF_END_%d:\n", if_end);
        }
        else if (s->type == FUNC_CALL_AST) func_call(fp, s->child, STtop);
    }
    if (stat->type == BREAK_AST) {
        if (label_sp < 1) {
            fprintf(stderr, "break used outside loop\n");
            exit(1);
        }
        fprintf(fp, "\tj\t\t%s\n\tnop\n", label_stack[label_sp-1]);
    }
    stmt_code(fp, stat->brother, STtop);
}


void calling_convention(FILE *fp)
{
    fprintf(fp, "\taddi\t$sp, $sp, -8\t# Colling convention\n");
    fprintf(fp, "\tsw\t\t$ra, 0($sp)\t# Saving $ra\n");
    fprintf(fp, "\tsw\t\t$fp, 4($sp)\t# Saving $fp\n");
    fprintf(fp, "\taddi\t$fp, $sp, 0\n");
}
void called_convention(FILE *fp)
{
    fprintf(fp, "\tlw\t\t$ra, 0($sp)\t# Call $ra\n");
    fprintf(fp, "\tlw\t\t$fp, 4($sp)\t# Call $fp\n");
    fprintf(fp, "\taddi\t$sp, $sp, 8\t# Colling convention\n");
    fprintf(fp, "\tjr\t\t$ra\n\tnop\n");
}
// オフセット値から変数名（配列なら添字付き）を検索する補助関数
char* get_var_name_by_offset(SymbolTable *STtop, int offset) {
    SymbolTable *cur = STtop;
    static char formatted_name[256]; // 名前を保持するためのバッファ

    while (cur) {
        if (!cur->is_arg) {
            int total_elements = 1;
            Index *idx = cur->index_size;
            
            // 配列かどうかの判定と要素数の計算
            if (idx != NULL) {
                while (idx) {
                    total_elements *= idx->size;
                    idx = idx->next;
                }
                
                // 配列のメモリ範囲: [base_offset, cur->offset]
                // ※あなたのコードでは、offset_p += 4 * index してからプッシュしているので
                // cur->offset が配列の末尾（最後のエレメント）を指しています
                int base_offset = cur->offset - (4 * (total_elements - 1));

                if (offset >= base_offset && offset <= cur->offset) {
                    // 何番目の要素かを計算 (0, 1, 2...)
                    int array_index = (cur->offset - offset) / 4;
                    // 多次元配列の場合でも、メモリ上の通し番号で "name[i]" と表示
                    snprintf(formatted_name, sizeof(formatted_name), "%s[%d]", cur->name, array_index);
                    return formatted_name;
                }
            } else {
                // 単純な変数の場合
                if (offset == cur->offset) {
                    return cur->name;
                }
            }
        }
        cur = cur->next;
    }
    return "unknown";
}
int Saving_main_define(FILE *fp, int offset_p, char *main, SymbolTable *STtop)
{
    int i = 0;
    if(!strncmp(main, "main", 4))
    {
        if (offset_p > 0) {
            for (i = 4; i <= offset_p; i = i + 4) {
                int reg_idx = Ruse(); 
                char *var_name = get_var_name_by_offset(STtop, i);
                fprintf(fp, "\tlw\t\t%s, %d($fp)\t# %s\n", printReg(reg_idx), -i, var_name);
            }
        }
        return offset_p;
    }
    return 0;
}

int func_code(FILE *fp, Node *n)
{
    int offset_p = 0;
    SymbolTable *Ftop = NULL;
    Node *func_name = n->child;
    fprintf(fp, "%s:\n", func_name->variable);
    calling_convention(fp);
    Node *arg = func_name->brother;
    offset_p = arg_code(fp, arg->child, offset_p, &Ftop);

    Node *decl = arg->brother;
    offset_p = decl_code(fp, decl->child, offset_p, &Ftop);
    fprintf(fp, "\taddi\t$sp, $sp, -%d\t# allocate local variables\n", offset_p);

    Node *stat = decl->brother;
    stmt_code(fp, stat->child, &Ftop);
    int main_offset = Saving_main_define(fp, offset_p, func_name->variable, Ftop);
    fprintf(fp, "\taddi\t$sp, $sp, %d\n", offset_p);
    called_convention(fp);
    return main_offset;
}

void gen_code(FILE *fp, Node *n)
{
    int main_offset = 0;
    init_code(fp);
    Node *func = n->child;
    while (func) {
        if (func->type == DECL_FUNCTION_AST && strcmp(func->child->variable, "main") == 0) {
            main_offset += func_code(fp, func);
        } else if (func->type == DECL_FUNCTION_AST) {
            func_code(fp, func);
        }
        func = func->brother;
    }
}
