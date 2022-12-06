type named_term =
    NamedVar of string
  | NamedAbs of string * named_term
  | NamedApp of named_term * named_term

type db_term =
    DBVar of int
  | DBAbs of db_term
  | DBApp of db_term * db_term
