# Untyped arithmetic expressions


## Project setup

```bash
dune init proj boolexpr
```

At the end of the file dune-project, add the following line:
```bash
(using menhir 2.1)
```

```bash
dune build
```

```bash
dune utop src
```
