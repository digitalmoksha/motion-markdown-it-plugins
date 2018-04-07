# markdown-it-mark

> `<mark>` tag plugin for [motion-markdown-it](https://github.com/digitalmoksha/motion-markdown-it) markdown parser.

_Ported from the [javascript version](https://github.com/markdown-it/markdown-it-mark). Synced with v2.0.0. Works with Ruby and RubyMotion._

`==marked==` => `<mark>inserted</mark>`

Markup uses the same conditions as CommonMark [emphasis](http://spec.commonmark.org/0.15/#emphasis-and-strong-emphasis).

## Usage

```ruby
md = MarkdownIt::Parser.new.use(MotionMarkdownItPlugins::Mark)

md.render('==marked==') # => '<p><mark>marked</mark></p>'
```
