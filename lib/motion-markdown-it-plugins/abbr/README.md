# markdown-it-abbr

> Abbreviation (`<abbr>`) tag plugin for [motion-markdown-it](https://github.com/digitalmoksha/motion-markdown-it) markdown parser.

_Ported from the [javascript version](https://github.com/markdown-it/markdown-it-abbr). Synced with v1.0.4. Works with Ruby and RubyMotion._

Markup is based on [php markdown extra](https://michelf.ca/projects/php-markdown/extra/#abbr) definition, but without multiline support.

Markdown:

```
*[HTML]: Hyper Text Markup Language
*[W3C]:  World Wide Web Consortium
The HTML specification
is maintained by the W3C.
```

HTML:

```html
<p>The <abbr title="Hyper Text Markup Language">HTML</abbr> specification
is maintained by the <abbr title="World Wide Web Consortium">W3C</abbr>.</p>
```

## Usage

```ruby
md = MarkdownIt::Parser.new.use(MotionMarkdownItPlugins::Abbr)

md.render(/*...*/) # see example above
```
