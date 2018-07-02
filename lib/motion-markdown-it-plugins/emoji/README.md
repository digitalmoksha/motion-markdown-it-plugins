# markdown-it-emoji

> Plugin for [motion-markdown-it](https://github.com/digitalmoksha/motion-markdown-it markdown parser, adding emoji & emoticon syntax support.

_Ported from the [javascript version](https://github.com/markdown-it/markdown-it-emoji/). Synced with v1.4.0. Works with Ruby and RubyMotion._

Syntax is based on [Emoji cheat sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet/).

## Usage

```ruby
md = MarkdownIt::Parser.new.use(MotionMarkdownItPlugins::Emoji)
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
