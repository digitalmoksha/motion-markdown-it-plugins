# markdown-it-ins

> `<ins>` tag plugin for [motion-markdown-it](https://github.com/digitalmoksha/motion-markdown-it) markdown parser.

_Ported from the [javascript version](https://github.com/markdown-it/markdown-it-ins). Works with Ruby and RubyMotion._

`++inserted++` => `<ins>inserted</ins>`

Markup uses the same conditions as CommonMark [emphasis](http://spec.commonmark.org/0.15/#emphasis-and-strong-emphasis).

## Usage

```ruby
md = MarkdownIt::Parser.new.use(MotionMarkdownItPlugins::Ins)

md.render('++inserted++') # => '<p><ins>inserted</ins></p>'
```
