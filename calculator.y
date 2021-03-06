%{
int yylex();
void yyerror(char *s);

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <math.h>

#include "myFunctions.h"
#include "uthash_library/uthash.h"

double ans = 0;                          // Previous result
int lineno = 1;                          // Number of current line

#define e  2.71828182845904523536028747135266249775724709369995
#define pi 3.14159265358979323846264338327950288419716939937510

// Hashtable to store the ID's with their value
struct id_struct {
    char name[8];         // Key
    double value;         // Value
    UT_hash_handle hh;
};

struct id_struct *idTable = NULL;

// Linked List to store a list of numbers
struct list_node {
    struct list_node  *next;
    double            value;
};
struct list {
    struct list_node  *head, **tail;
};

// Return a new list
struct list *new_list() {
    struct list *new_list = malloc(sizeof(struct list));
    new_list->head = NULL;
    new_list->tail = &new_list->head;
    return new_list;
}

// Add an element at the end of the list
void push_back(struct list *list, double value) {
    struct list_node *node = malloc(sizeof(struct list_node));
    node->next = NULL;
    node->value = value;
    *list->tail = node;
    list->tail = &node->next;
}

// Get the length of the list
int getListLength(struct list *list){
    struct list_node *cursor = malloc(sizeof(struct list_node));
    int counter = 0;
    cursor = list->head;
    while(cursor != NULL){
        counter = counter + 1;
        cursor = cursor->next;
    }
    return counter;
}


#define prompt printf("\n%3d : ",++lineno)
%}


%union {
    char* lexeme;			//identifier
    double value;			//value of an identifier of type NUM
    int digit;              //value of an identifier of type DIGIT
    struct list *data_list;
}

%start line

%token <value> NUM
%token <digit> DIGIT
%token <lexeme> ID

%token PLUS MINUS MULT DIV POW FACT PER MOD EXP EUL PI SQRT CBRT HYPOT LN LOG10 ABS GCD LCM INTDIV BIN DEC
%token MEAN VARIANCE SD SUM PROD DIM DOTP MAX MIN POLYEVAL
%token COS SIN TAN SINH COSH TANH ASIN ACOS ATAN ATAN2 ASINH ACOSH ATANH CEIL FLOOR COMP BTD DTB NOT AND OR NAND NOR XOR
%token ANS RAND ASSIGN COMMA OPEN CLOSE CURO CURC SQBO SQBC ENDOFLINE EMPTY EXIT
%token PROZENT


%type <value> expr
%type <value> term
%type <value> power
%type <value> factorial
%type <value> exponent
%type <value> percent
%type <value> final
%type <data_list> list
%type <value> dimlist
%type <value> maxlist
%type <value> minlist

%%

line    : // Empty
        | expr ASSIGN ID {
                    struct id_struct *s = NULL;
                    s = (struct id_struct*)malloc(sizeof(struct id_struct));
                    strncpy(s->name, $3, 8);
                    s->value = $1;
                    HASH_ADD_STR( idTable, name, s );
                    ans = $1;
                    printf("%.11g",$1);
                    prompt;
          } ENDOFLINE line
        | expr {
                    ans = $1;
                    printf("%.11g",$1);
                    prompt;
          } ENDOFLINE line
        | expr ASSIGN ID error ENDOFLINE { yyerrok; yyclearin; } line
        | expr error ENDOFLINE { yyerrok; yyclearin; } line
        | error ENDOFLINE { yyerrok; yyclearin; } line
        ;

expr    : expr PLUS term { $$ = $1 + $3; }
        | expr MINUS term { $$ = $1 - $3; }
        | term { $$ = $1; }
        ;

term    : term MULT power { $$ = $1 * $3; }
        | term DIV power { $$ = $1 / $3; }
        | power { $$ = $1; }
        ;

power   : power POW factorial { $$ = pow( $1, $3 ); }
        | factorial { $$ = $1; }
        ;

factorial   : factorial FACT { $$ = fac($1); }
            | exponent { $$ = $1; }
            ;

exponent: exponent EXP percent { $$ = $1 * pow( 10, $3 ); }
        | percent { $$ = $1; }
        ;

percent : percent PER { $$ = $1 / 100; }
        | final { $$ = $1; }
        ;

final   : MOD OPEN expr COMMA expr CLOSE { $$ = fmod( $3, $5 ); }
        | EUL expr CLOSE { $$ = pow( e, $2 ); }
        | SQRT OPEN expr CLOSE { $$ = sqrt( $3 ); }
        | CBRT OPEN expr CLOSE { $$ = cbrt( $3 ); }
        | HYPOT OPEN expr COMMA expr CLOSE { $$ = hypot( $3, $5 ); }
        | ABS OPEN expr CLOSE { $$ = fabs( $3 ); }
        | GCD OPEN expr COMMA expr CLOSE { $$ = gcd( $3, $5 ); }
        | LCM OPEN expr COMMA expr CLOSE { $$ = lcm( $3, $5 ); }
        | INTDIV OPEN expr COMMA expr CLOSE { div_t res = div($3, $5); $$ = res.quot;}

        | LN OPEN expr CLOSE { $$ = log( $3 ); }
        | LOG10 OPEN expr CLOSE { $$ = log10( $3 ); }

        | SIN OPEN expr CLOSE { $$ = sin( $3 ); }
        | COS OPEN expr CLOSE { $$ = cos( $3 ); }
        | TAN OPEN expr CLOSE { $$ = tan( $3 ); }
        | SINH OPEN expr CLOSE { $$ = sinh( $3 ); }
        | COSH OPEN expr CLOSE { $$ = cosh( $3 ); }
        | TANH OPEN expr CLOSE { $$ = tanh( $3 ); }
        | ASIN OPEN expr CLOSE { $$ = asin( $3 ); }
        | ACOS OPEN expr CLOSE { $$ = acos( $3 ); }
        | ATAN OPEN expr CLOSE { $$ = atan( $3 ); }
        | ATAN2 OPEN expr COMMA expr CLOSE { $$ = atan2( $3, $5 ); }
        | ASINH OPEN expr CLOSE { $$ = asinh( $3 ); }
        | ACOSH OPEN expr CLOSE { $$ = acosh( $3 ); }
        | ATANH OPEN expr CLOSE { $$ = atanh( $3 ); }

        | CEIL OPEN expr CLOSE { $$ = ceil( $3 ); }
        | FLOOR OPEN expr CLOSE { $$ = floor( $3 ); }

        | RAND OPEN CLOSE { $$ =  (double)rand() / (double)RAND_MAX; }

        | COMP OPEN expr COMMA expr CLOSE { $$ = comp( $3, $5 ); }

        | BTD OPEN expr CLOSE { double res = binToDec( $3 ); if(res==-1){YYERROR;} $$ = res; }
        | DTB OPEN expr CLOSE { $$ = decToBin( $3 ); }

        | AND OPEN expr COMMA expr CLOSE { double res = and( $3, $5 ); if(res==-1){YYERROR;} $$ = res; }
        | OR OPEN expr COMMA expr CLOSE { double res = or( $3, $5 ); if(res==-1){YYERROR;} $$ = res; }
        | NAND OPEN expr COMMA expr CLOSE { double res = nand( $3, $5 ); if(res==-1){YYERROR;} $$ = res; }
        | NOR OPEN expr COMMA expr CLOSE { double res = nor( $3, $5 ); if(res==-1){YYERROR;} $$ = res;}
        | XOR OPEN expr COMMA expr CLOSE { double res = xor( $3, $5 ); if(res==-1){YYERROR;} $$ = res; }
        | NOT OPEN expr CLOSE { $$ = not( $3 ); }

        | SUM OPEN CURO list CURC CLOSE {
            struct list_node *cursor = malloc(sizeof(struct list_node));
            double sum = 0;
            if($4 != NULL){
                cursor = $4->head;
                while(cursor != NULL){
                    sum += cursor->value;
                    cursor = cursor->next;
                }
            }
            $$ = sum;
          }
        | PROD OPEN CURO list CURC CLOSE {
            struct list_node *cursor = malloc(sizeof(struct list_node));
            double product = 0;
            if($4 != NULL){
                cursor = $4->head;
                product = cursor->value;
                cursor = cursor->next;
                while(cursor != NULL){
                    product *= cursor->value;
                    cursor = cursor->next;
                }
            }
            $$ = product;
          }
        | MEAN OPEN CURO list CURC CLOSE {
            struct list_node *cursor = malloc(sizeof(struct list_node));
            double sum = 0;
            int counter = 0;
            if($4 != NULL){
                cursor = $4->head;
                while(cursor != NULL){
                    sum += cursor->value;
                    counter += 1;
                    cursor = cursor->next;
                }
                $$ = sum / counter;
            }else{
                yyerror("undef");
                YYERROR;
            }
          }
        | VARIANCE OPEN CURO list CURC CLOSE {
            struct list_node *cursor = malloc(sizeof(struct list_node));
            double sum = 0;
            double sum2 = 0;
            int counter = 0;
            if($4 != NULL && getListLength($4) > 1){
                cursor = $4->head;
                while(cursor != NULL){
                    sum += cursor->value;
                    counter += 1;
                    cursor = cursor->next;
                }
                double mean = sum / counter;
                cursor = $4->head;
                while(cursor != NULL){
                    sum2 += pow((cursor->value - mean), 2);
                    cursor = cursor->next;
                }
                $$ = sum2 / counter;
            }else{
                yyerror("Dimension");
                YYERROR;
            }
          }
        | SD OPEN CURO list CURC CLOSE {
            struct list_node *cursor = malloc(sizeof(struct list_node));
            double sum = 0;
            double sum2 = 0;
            int counter = 0;
            if($4 != NULL && getListLength($4) > 1){
                cursor = $4->head;
                while(cursor != NULL){
                    sum += cursor->value;
                    counter = counter + 1;
                    cursor = cursor->next;
                }
                double mean = sum / counter;
                cursor = $4->head;
                while(cursor != NULL){
                    sum2 += pow((cursor->value - mean), 2);
                    cursor = cursor->next;
                }
                $$ = sqrt(sum2 / counter);
            }else{
                yyerror("Dimension");
                YYERROR;
            }
          }
        | DOTP OPEN CURO list CURC COMMA CURO list CURC CLOSE {
            struct list_node *cursor1 = malloc(sizeof(struct list_node));
            struct list_node *cursor2 = malloc(sizeof(struct list_node));
            double dotp = 0;
            if($4 == NULL && $8 == NULL){
                $$ = dotp;
            }else if($4 != NULL && $8 != NULL && getListLength($4) == getListLength($8)){
                cursor1 = $4->head;
                cursor2 = $8->head;
                while(cursor1 != NULL){
                    dotp += (cursor1->value * cursor2->value);
                    cursor1 = cursor1->next;
                    cursor2 = cursor2->next;
                }
                $$ = dotp;
            }else{
                yyerror("Data type");
                YYERROR;
            }
          }
        | POLYEVAL OPEN CURO list CURC COMMA expr CLOSE {
            struct list_node *cursor = malloc(sizeof(struct list_node));
            double poly = 0;
            if($4 == NULL){
                $$ = poly;
            }else{
                cursor = $4->head;
                int exp_counter = getListLength($4)-1;
                while(cursor != NULL){
                    poly += (cursor->value * pow($7, exp_counter));
                    exp_counter -= 1;
                    cursor = cursor->next;
                }
                $$ = poly;
            }
          }
        | DIM OPEN CURO dimlist CURC CLOSE { $$ = $4 ; }
        | MAX OPEN CURO maxlist CURC CLOSE { $$ = $4 ; }
        | MIN OPEN CURO minlist CURC CLOSE { $$ = $4 ; }

        | OPEN expr CLOSE { $$ = $2; }
        | PI { $$ = pi; }
        | NUM { $$ = $1; }
        | MINUS NUM { $$ = -$2; }
        | ANS { $$ = ans; }
        | ID {
                struct id_struct *s = NULL;
                HASH_FIND_STR( idTable, $1, s);
                if(s){
                    $$ = s->value;
                }else{
                    yyerror("Variable not declared");
                    YYERROR;
                }
              }

        | EXIT { exit(0); }
        ;

list    : expr { push_back($$ = new_list(), $1); }
        | list COMMA expr { push_back($$ = $1, $3); }
        | { $$ = NULL; }
        ;


dimlist : expr COMMA dimlist {  $$ = 1 + $3; }
        | expr  { $$ = 1; }
        | { $$ = 0; }
        ;

maxlist : expr COMMA maxlist {
              if($1 > $3){
                $$ = $1;
              }else{
                $$ = $3;
              }
          }
        | expr  { $$ = $1; }
        | { yyerror("Infinity"); YYERROR; }
        ;

minlist : expr COMMA minlist {
              if($1 > $3){
                $$ = $3;
              }else{
                $$ = $1;
              }
          }
        | expr  { $$ = $1; }
        | { yyerror("-Infinity"); YYERROR; }
        ;

%%

#include "lex.yy.c"

void yyerror(char *s)
{
    fprintf (stderr, "%s", s);
    lineno--;
    prompt;
}

int main(void)
{
    printf("%3d : ", lineno);
    yyparse();
    return(0);
}