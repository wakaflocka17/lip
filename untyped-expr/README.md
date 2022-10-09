# Untyped arithmetic expressions

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
opam install -y utop menhir
```
