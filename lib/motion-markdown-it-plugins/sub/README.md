# markdown-it-sub

> Subscript (`<sub>`) tag plugin for [motion-markdown-it](https://github.com/digitalmoksha/motion-markdown-it) markdown parser.

_Ported from the [javascript version](https://github.com/markdown-it/markdown-it-sub). Synced with v1.0.0.  Works with Ruby and RubyMotion._

`H~2~0` => `H<sub>2</sub>O`

Markup is based on [pandoc](http://johnmacfarlane.net/pandoc/README.html#superscripts-and-subscripts) definition. But nested markup is currently not supported.

## Usage

```ruby
md = MarkdownIt::Parser.new.use(MotionMarkdownItPlugins::Sub)

md.render('H~2~0') # => '<p>H<sub>2</sub>O</p>'
```
