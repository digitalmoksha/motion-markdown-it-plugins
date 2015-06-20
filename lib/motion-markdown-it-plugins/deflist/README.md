# markdown-it-deflist

> Definition list (`<dl>`) tag plugin for [motion-markdown-it](https://github.com/digitalmoksha/motion-markdown-it) markdown parser.

_Ported from the [javascript version](https://github.com/markdown-it/markdown-it-deflist). Synced with v1.0.0. Works with Ruby and RubyMotion._

Syntax is based on [pandoc definition lists](http://johnmacfarlane.net/pandoc/README.html#definition-lists).

## Usage

```ruby
md = MarkdownIt::Parser.new.use(MotionMarkdownItPlugins::Deflist)
md.render(text)

Markup Example:

Term 1
: Definition 1

Term 2
  ~ Definition 2a
  ~ Definition 2b


Output:

<dl>
<dt>Term 1</dt>
<dd>Definition 1</dd>
<dt>Term 2</dt>
<dd>Definition 2a</dd>
<dd>Definition 2b</dd>
</dl>

```
