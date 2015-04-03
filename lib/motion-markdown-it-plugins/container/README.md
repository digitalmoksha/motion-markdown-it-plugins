# markdown-it-container

> Plugin for creating block-level custom containers for [motion-markdown-it](https://github.com/digitalmoksha/motion-markdown-it) markdown parser.

_Ported from the [javascript version](https://github.com/markdown-it/markdown-it-container). Works with Ruby and RubyMotion._

With this plugin you can create a block container like:

```
::: warning
*here be dragons*
:::
```

.... and specify how it should be rendered. If no renderer is defined, `<div>` with a container name class will be created:

```html
<div class="warning">
<em>here be dragons</em>
</div>
```

Markup is the same as for [fenced code blocks](http://spec.commonmark.org/0.18/#fenced-code-blocks).
Difference is, that the marker uses a different character and the content is rendered as markdown.

## API

```ruby
md = MarkdownIt::Parser.new.use(MotionMarkdownItPlugins::Container, name, options)
```

Params:

- __name__ - container name (mandatory)
- __options:__ (optional)
   - __validate__ - optional, function to validate tail after opening marker, should return `true` on success.
   - __render__ - optional, renderer function for opening/closing tokens.
   - __marker__ - optional (`:`), character to use in delimiter.


## Example

```ruby
md = MarkdownIt::Parser.new.
md.use(MotionMarkdownItPlugins::Container,'spoiler',
    { validate: lambda {|params| params.strip.match(/^spoiler\s+(.*)$/) },
      render: lambda {|tokens, idx, _options, env, renderer|
        m = tokens[idx].info.strip.match(/^spoiler\s+(.*)$/)
        if (tokens[idx].nesting == 1)
          # opening tag
          "<details><summary>#{m[1]}</summary>\n"
        else
          # closing tag
          "</details>\n"
        end
      }
    })

puts md.render("::: spoiler click me\n*content*\n:::\n")

# Output:
#
# <details><summary>click me</summary>
# <p><em>content</em></p>
# </details>
```
