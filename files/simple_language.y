%{
#include <iostream>
#include <string>
#include <map>
static std::map<std::string, int> vars;
inline void yyerror(const char *str) { std::cout << str << std::endl; }
int yylex();

void print_tabs(int count);
void print_assignment(const std::string &id, int value);
void print_expression(int left, char op, int right);
void print_number(int num);
void print_id(const std::string &id);
%}

%union { int num; std::string *str; }

%token<num> NUMBER
%token<str> ID
%type<num> expression
%type<num> assignment

%right '='
%left '+' '-'
%left '*' '/'

%%

program: statement_list
        ;

statement_list: statement
    | statement_list statement
    ;

statement: assignment
    | expression ':' { std::cout << $1 << std::endl; }
    ;

assignment: ID '=' expression
    { 
        printf("Assign %s = %d\n", $1->c_str(), $3); 
        $$ = vars[*$1] = $3; 
        print_assignment(*$1, $3);
        delete $1;
    }
    ;

expression: NUMBER { 
        $$ = $1; 
        print_number($1);
    }
    | ID { 
        $$ = vars[*$1]; 
        print_id(*$1);
        delete $1;
    }
    | expression '+' expression { 
        $$ = $1 + $3; 
        print_expression($1, '+', $3);
    }
    | expression '-' expression { 
        $$ = $1 - $3; 
        print_expression($1, '-', $3);
    }
    | expression '*' expression { 
        $$ = $1 * $3; 
        print_expression($1, '*', $3);
    }
    | expression '/' expression { 
        $$ = $1 / $3; 
        print_expression($1, '/', $3);
    }
    ;

%%

int main() {
    yyparse();
    return 0;
}

void print_tabs(int count) {
    for (int i = 0; i < count; i++) {
        std::cout << "\t";
    }
}

void print_assignment(const std::string &id, int value) {
    std::cout << "ASSIGNMENT(ID(" << id << "), " << value << ")" << std::endl;
}

void print_expression(int left, char op, int right) {
    std::cout << "EXPRESSION(" << left << " " << op << " " << right << ")" << std::endl;
}

void print_number(int num) {
    std::cout << "NUMBER(" << num << ")" << std::endl;
}

void print_id(const std::string &id) {
    std::cout << "ID(" << id << ")" << std::endl;
}

