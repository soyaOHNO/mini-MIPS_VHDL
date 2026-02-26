%{
    #include "compiler.tab.h"
%}

%option noyywrap
%option nounput
%option noinput

%%
[ \t\n]                 ;
"define"                {return DEFINE;}
"func"                  {return FUNC;}
"funccall"              {return FUNCCALL;}
"array"                 {return ARRAY;}
"while"                 {return WHILE;}
"for"                   {return FOR;}
"if"                    {return IF;}
"else"                  {return ELSE;}
"break"                 {return BREAK;}
";"                     {return SEMIC;}
"["                     {return L_BRACKET;}
"]"                     {return R_BRACKET;}
"("                     {return L_PARAN;}
")"                     {return R_PARAN;}
"{"                     {return L_BRACE;}
"}"                     {return R_BRACE;}
"="                     {return ASSIGN;}
"+"                     {return ADD;}
"-"                     {return SUB;}
"*"                     {return MUL;}
"/"                     {return DIV;}
"%"                     {return MOD;}
"++"                    {return INC;}
"--"                    {return DEC;}
"=="                    {return EQ;}
"<="                    {return EL;}
">="                    {return EG;}
"<"                     {return LT;}
">"                     {return GT;}
"&&"                    {return LAND;}
"||"                    {return LOR;}
[a-zA-Z][a-zA-Z0-9]*    {yylval.str = (char*)malloc(sizeof(char) * yyleng);
                         strncpy(yylval.str , yytext, yyleng);
                         return IDENT;}
[0-9]+                  {yylval.num = atoi(yytext); return NUMBER;}
","                     {return COMMA;}
"."                     {return yytext[0];}

%%
