# markdown-it-sup

> Superscript (`<sup>`) tag plugin for [motion-markdown-it](https://github.com/digitalmoksha/motion-markdown-it) markdown parser.

_Ported from the [javascript version](https://github.com/markdown-it/markdown-it-sup). Synced with v1.0.0. Works with Ruby and RubyMotion._

`29^th^` => `29<sup>th</sup>`

Markup is based on [pandoc](http://johnmacfarlane.net/pandoc/README.html#superscripts-and-subscripts) definition. But nested markup is currently not supported.

## Usage

```js
md = MarkdownIt::Parser.new.use(MotionMarkdownItPlugins::Sup)

md.render('29^th^') # => '<p>29<sup>th</sup></p>'
```
