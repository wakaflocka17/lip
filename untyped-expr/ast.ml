type boolExp = True
             | False
             | Or of boolExp * boolExp
             | If of boolExp * boolExp * boolExp
;;
