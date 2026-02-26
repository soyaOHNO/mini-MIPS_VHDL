CC = gcc
CFLAGS = -Wall -g
LEX = flex
YACC = bison

# 生成ターゲット
TARGET = mycompiler

# オブジェクトファイル
OBJS = compiler.tab.o lex.yy.o ast.o code_generation.o optimization.o assembler.o mips_utils.o

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

compiler.tab.c compiler.tab.h: compiler.y
	$(YACC) -d compiler.y

lex.yy.c: compiler.l compiler.tab.h
	$(LEX) compiler.l

# 各ソースのコンパイル
%.o: %.c
	$(CC) $(CFLAGS) -c $<

# クリーンアップ
clean:
	rm -f $(TARGET) *.o compiler.tab.c compiler.tab.h lex.yy.c a.s a_opt.s InstructionMemory.mif