%{
open Ast
%}

%token TRUE
%token FALSE
%token LPAREN
%token RPAREN
%token OR
%token IF
%token THEN
%token ELSE
%token EOF

%start <Ast.boolExp> prog

%%

prog:
  | e = expr; EOF { e }
;

expr:
  | TRUE { True }
  | FALSE { False }
  | e1 = expr; OR; e2 = expr; { Or(e1, e2) }
  | IF; e1 = expr; THEN; e2 = expr; ELSE; e3 = expr; { If(e1, e2, e3) }
  | LPAREN; e=expr; RPAREN {e}
;

