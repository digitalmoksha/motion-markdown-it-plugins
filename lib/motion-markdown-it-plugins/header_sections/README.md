# markdown-it-header-sections

> Wrap headers in sections plugin for [motion-markdown-it](https://github.com/digitalmoksha/motion-markdown-it) markdown parser.

_Ported from the [javascript version](https://github.com/arve0/markdown-it-header-sections) by @openbrian. Synced with v1.0.0. Works with Ruby and RubyMotion._

Renders this markdown
```md
# Header 1
Text.
### Header 2
Lorem?
## Header 3
Ipsum.
# Last header
Markdown rules!
```

to this output (without indentation)
```html
<section>
  <h1>Header 1</h1>
  <p>Text.</p>
  <section>
    <h3>Header 2</h3>
    <p>Lorem?</p>
  </section>
  <section>
    <h2>Header 3</h2>
    <p>Ipsum.</p>
  </section>
</section>
<section>
  <h1>Last header</h1>
  <p>Markdown rules!</p>
</section>
```

this markdown
```md
# great stuff {.jumbotron}
lorem

click me {.btn .btn-default}
```

renders to
```md
<section class="jumbotron">
  <h1 class="jumbotron">great stuff</h1>
  <p>lorem</p>
  <p class="btn btn-default">click me</p>
</section>
```

## Install
```
gem install motion-markdown-it-plugins
```

## Usage
```ruby
require 'motion-markdown-it'
require 'motion-markdown-it-plugins'

src = open('doc/Design.md').read;

parser = MarkdownIt::Parser.new(:commonmark, { html: false })
  .use(MotionMarkdownItPlugins::CheckboxReplace, {})
  .use(MotionMarkdownItPlugins::HeaderSections, {})

html = parser.render(src);
```
