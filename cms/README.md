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
