# Weekly Haskell-study session 24.11.2018

## Topics covered

- Quick overview of some important components in the haskell ecosystem:
    - GHC - the Haskell compiler
    - Cabal - a tool for building projects
    - Stack - a tool for building projects and setting up the Haskell environment
    - [Hoogle](https://hoogle.haskell.org) - a search engine over the Haskell ecosystem
- GHCi (repl) :type, :info, :load, :module ...
- Basic syntax, module, function declaration
- Reading and printing to the console
- The IO monad
- `(>>=)`, `(>>)` ("bind" and "then" functions for combining actions)
- Type classes
- Language pragmas
- Laziness

## Links

- [GHC extension documentation](https://downloads.haskell.org/~ghc/8.6.1/docs/html/users_guide/glasgow_exts.html)
  and an [unofficial guide](https://limperg.de/ghc-extensions/)

- [Standard typeclasses in Prelude](https://hackage.haskell.org/package/base-4.12.0.0/docs/Prelude.html#g:4)

- Attaching side-effects to pure expressions with
  [`trace`](https://hackage.haskell.org/package/base-4.12.0.0/docs/src/Debug.Trace.html#trace)
