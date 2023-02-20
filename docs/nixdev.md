
# NIX LAND

[link to source](https://nix.dev/tutorials/nix-language)

Most common patterns in nix, which are to be covered in this tutorial:

- assigning names and accessing values
- declaring and calling functions
- built-in and library functions
- impurities to obtain build inputs
- derications that describe build tasks



# Evaluating nix files

```bash
  nix-instantiate --eval file.nix
```


`nix-instantiate --eval` will evaluate default.nix if no file name is specified.

The Nix language by default uses lazy evaluation, and will only compute values when needed.

Some examples show results of strict evaluation for clarity.
If your output does not match the example, try adding the ``--strict` option to `nix-instantiate`.

```bash
  nix-instantiate --eval --strict file.nix
```


# Nix is for building
The purpose of the Nix language is to create build tasks: 
precise descriptions of how contents of existing files are used to derive new files.

A build task in Nix is called a **derivation**.

The language is pure, that is, its evaluation does not observe or interact with the outside world 
– with one notable exception: reading files, to capture what build tasks will operate on.


# Whitespace

Whitespace is insignificant, other than that it is used to delimit lexical tokens where required.

But also list elements are separated by white space

# Names and Values

There are 2 ways to assign names to values:

1. attribute sets
2. `let` expressions

# Attribute Sets

Attribute sets are kind of like JSON.

```nix
  {
    string = "hello";
    integer = 1;
    float = 3.141;
    bool = true;
    null = null;
    list = [ 1 "two" false ];
    attribute-set = {
      a = "hello";
      b = 2;
      c = 2.718;
      d = false;
    }; # comments are supported
  }
```

- Attribute names usually do not need quotes
- List elements are separated by white space


# Recursive Attribute Sets

You will sometimes see attribute sets declared with `rec` prepended. 
This allows access to attributes from within the set.

```nix
  rec {
    one = 1;
    two = one + 1;
    three = two + 1;
  }
```

So obviously the order matters in this situation.


# Let... in... Expressions

```nix
let
  a = 1;
in
  a + a
```

Assignments are placed between the keywords `let` and `in`. 
In this example we assign `a = 1`.


After in comes the expression in which the assignments are valid, 
i.e., where assigned names can be used. In this example the expression is `a + a`, where `a` refers to `a = 1`.

# Attribute Access

```nix
let
  attrset = { a = { b = { c = 1; }; }; };
in
  attrset.a.b.c
```

You can also assign via `.`

```nix
{ a.b.c = 1; }
```

# with ...; ...

The `with` expression allows access to attributes without repeatedly referencing their attribute set.

```nix
let
  a = {
     x = 1;
     y = 2;
     z = 3;
  };
  in
  with a; [ x y z ]
```

So this evaluates to:

```nix
[ 1 2 3 ]
```

Attributes made available through with are only in scope of the expression following the semicolon (;).


WRONG:

```nix
let
  a = {
    x = 1;
    y = 2;
    z = 3;
  };
  in
  {
     b = with a; [ x y z ];
     c = x;
  }
```

# inherit ...

`inherit` is shorthand for assigning the value of a name from an existing scope to the same name in a nested scope. 
It is for convenience to avoid repeating the same name multiple times.

```nix
let
  x = 1;
  y = 2;
in
{
  inherit x y;
}
```

Kinda don't get what this does?

It says: While this example is contrived, in more complex code you will 
regularly see nested let expressions that re-use names from their outer scope.




# Antiquotation ${ ... } AKA string interpolation

```nix
let
  name = "Nix";
in
  "hello ${name}"
```

The value of a Nix expression can be inserted into a character string with the dollar-sign and braces (`${ }`).

Only character strings or values that can be represented as a character string are allowed.

So an int wouldn't work.

WRONG:

```nix
let
  x = 1;
in
  "${x} + ${x} = ${x + x}"
```

It can be arbitrarily nested. (but that looks terrible so not reccommended).


# File Paths

Absolute paths start with a slash `/`.

Relative paths start with a dot `./`.

Paths can be used in antiquotation – an impure operation (to be covered later).

# Search Path

Also known as “angle bracket syntax”.

```nix
<nixpkgs>
```

```nix
/nix/var/nix/profiles/per-user/root/channels/nixpkgs
```


```nix
<nixpkgs/lib>
```

```nix
/nix/var/nix/profiles/per-user/root/channels/nixpkgs/lib
```

While you will see many such examples, we recommend to avoid search paths in practice,
as they are impurities which are not reproducible.



# Indented strings

Also known as “multi-line strings”.

The Nix language offers convenience syntax for character strings which span multiple lines that have common indentation.


```nix
''
multi
line
string
''
```

`"multi\nline\nstring"`


# Functions

A function always takes exactly one argument. 
Argument and function body are separated by a colon (`:`).


Single argument `x: x + 1`

Attribute set argument `{a, b}: a + b`

Attribute set argument (with defaults) `{a, b ? 0}: a + b`

Attribute set argument (with additional attributes allowed) `{a, b, ...}: a + b`

Named attribute set:

`args@{ a, b, ... }: a + b + args.c`

or:

`{ a, b, ... }@args: a + b + args.c`


Functions have no names. We say they are anonymous, and call such a function a lambda.


# Calling Functions

Also known as “function application”.


```nix
let
  f = x: x.a;
in
  f { a = 1; }
```
Returns `1`.

Can also pass arguments by name.

```nix
let
  f = x: x.a;
  v = { a = 1; };
in
  f v
```

# Currying

`x: y: x + y`


# Function Libraries

There are two widely used libraries that together can be considered standard for the Nix language.
You need to know about both to understand and navigate Nix language code.


`builtins`

Also known as “primitive operations” or “primops”.

Nix comes with many functions that are built into the language. 
They are implemented in C++ as part of the Nix language interpreter.

[link to nix manual on builtins]("https://nixos.org/manual/nix/stable/language/builtins.html")

example: `builtins.toString`


Most built-in functions are only accessible through builtins. 
A notable exception is `import`, which is also available at the top level.


`import` takes a path to a Nix file, reads it to evaluate the contained Nix expression, and returns the resulting value.

```bash
echo 1 + 2 > file.nix
```

```nix
import ./file.nix
```

Evaluates to: `3`.


`pkgs.lib`

The nixpkgs repository contains an attribute set called lib, which provides a large number of useful functions. 
They are implemented in the Nix language, as opposed to builtins, which are part of the language itself.



# Impurities

There is only one impurity in the Nix language that is relevant here: 
reading files from the file system as build inputs.

Build inputs are files that build tasks refer to in order to describe how to derive new files. 
When run, a build task will only have access to explicitly declared build inputs.

The only way to specify build input in the Nix is explicitly with:

- file system paths
- dedicated functions

Whenever a file system path is rendered to a character string with antiquotation, 
the contents of that file are copied to a special location in the file system, the Nix store, as a side effect.

```bash
echo 123 > data
```

`"${./data}"` (converting to character string via antiquotation)


`"/nix/store/h1qj5h5n05b5dl5q4nldrqq8mdg7dhqk-data"`


The Nix store path is obtained by taking the hash of 
the file’s contents (<hash>) 
and combining it with the file name (<name>). 

The file is copied into the Nix store directory /nix/store as a side effect of evaluation:


```
  /nix/store/<hash>-<name>
```


It is an error if the file system path does not exist.

For directories the same thing happens:
The entire directory (including nested files and directories) is copied to the Nix store, 
and the evaluated string becomes the Nix store path of the directory.



# Fetchers


- `builtins.fetchurl`
- `builtins.fetchTarball`
- `builtins.fetchGit`
- `builtins.fetchClosure`



Some of them add extra convenience, such as automatically unpacking archives.
`fetchTarball` will do that.



# Derivations

A build task in Nix is called a derivation.

- the Nix language is used to descibe build tasks

- Nix runs build tasks to produce build results

- Build results can in turn be used as inputs for other build tasks

The Nix language primitive to declare a build task is the built-in impure function `derivation`.

It is usually wrapped by the Nixpkgs build mechanism `stdenv.mkDerivation`, 
which hides much of the complexity involved in non-trivial build procedures.
You will probably never see `derivation` in practice.




# Shell Environment


```nix
{ pkgs ? import <nixpkgs> {} }:
let
  message = "hello world";
in
  pkgs.mkShell {
    buildInputs = with pkgs; [ cowsay ];
    shellHook = ''
       cowsay ${message}
       '';
  }
```


This example declares a shell environment (which runs the shellHook on initialization).

# Package Derivation Example

```nix
{ lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "hello";
  version = "2.12";
      
  src = builtins.fetchTarball {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1ayhp9v4m4rdhjmnl2bq3cibrbqqkgjbl3s7yk2nhlh8vj3ay16g";
  };
  
  meta = with lib; {
    license = licenses.gpl3Plus;
  };
}
```




