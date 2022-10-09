# Untyped arithmetic expressions


## Opam installation

Full instructions here: [opam installation](https://cs3110.github.io/textbook/chapters/preface/install.html)

```bash
sudo apt install opam
```

```bash
opam init --bare -a -y
```

```bash
opam switch create lip ocaml-base-compiler.4.14.0
```

```bash
eval $(opam env)
```

Logout, re-open your terminal, and run:
```bash
opam switch list
```

```bash
opam install -y utop menhir merlin
```

## Project setup

```bash
dune init proj boolexpr
```

At the end of the file dune-project, add the following line:
```bash
(using menhir 2.1)
```

```bash
dune utop src
```
