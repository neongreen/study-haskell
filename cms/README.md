# Content Management System

Renders Mustache templates (`%name%.mustache` + `%name%.yaml`) and serves
them under `/:name`.

Used libraries:

* [lucid](https://hackage.haskell.org/package/lucid) -- the HTML combinator library
* [servant](https://hackage.haskell.org/package/servant) -- server
* [stache](https://hackage.haskell.org/package/stache) -- Mustache rendering

Posts:

* How Servant works: [Implementing a minimal version of haskell-servant](https://www.well-typed.com/blog/2015/11/implementing-a-minimal-version-of-haskell-servant)
* `Proxy api` vs. `@api`: [Proxy arguments in class methods: a comparative analysis](https://ryanglscott.github.io/2019/02/06/proxy-arguments-in-class-methods/)
* [Polyvariadic functions in Haskell](https://github.com/AJFarmar/haskell-polyvariadic#how-can-we-describe-polyvariadic-functions-in-haskell)
* A technique for improving type inference for polyvariadic functions: [Variable-arity zipWith](https://typesandkinds.wordpress.com/2012/11/26/variable-arity-zipwith/)
* List of safe default extensions used at Wire: [package-defaults.yaml](https://github.com/wireapp/wire-server/blob/13d0981a20466bd21ebb43177a0e408b743d8a2b/package-defaults.yaml#L7-L45)
