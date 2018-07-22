# markdown-it-emoji

> Plugin for [motion-markdown-it](https://github.com/digitalmoksha/motion-markdown-it) markdown parser, adding emoji & emoticon syntax support.

_Ported from the [javascript version](https://github.com/markdown-it/markdown-it-emoji). Synced with v1.4.0. Works with Ruby and RubyMotion._

---

Two versions:

- __Full__ (default), with all github supported emojis.
- [Light](https://github.com/markdown-it/markdown-it-emoji/blob/master/lib/data/light.json), with only well-supported unicode emojis and reduced size.

Also supports emoticons [shortcuts](https://github.com/markdown-it/markdown-it-emoji/blob/master/lib/data/shortcuts.js) like `:)`, `:-(`, and others. See the full list in the link above.


## Use

```ruby
md = MarkdownIt::Parser.new
md.use(MotionMarkdownItPlugins::Emoji)   # Full version
# md.use(MotionMarkdownItPlugins::EmojiLight) # Light version

puts md.render("Yeah this works :smile: :-(")
```

output s`<p>Yeah this works 😄 😦</p>`

Options are not mandatory:

- __defs__ (Hash) - rewrite available emoji definitions
  - example: `{ "one" => "!!one!!", "fifty" = "!!50!!" }`
- __enabled__ (Array) - disable all emojis except those whitelisted
- __shortcuts__ (Hash) - rewrite default shortcuts
  - example: `{ "smile" => [ ":)", ":-)" ], "laughing" => ":D" }`

```ruby
md = MarkdownIt::Parser.new
md.use(MotionMarkdownItPlugins::Emoji, {
  defs: {
    'one' => '!!!one!!!',
    'fifty' => '!!50!!'
  },
  shortcuts: {
    'fifty' => [ ':50', '|50' ],
    'one' => ':uno'
  }
})

md.render("Yeah this works :one: :50")
```

outputs: `<p>Yeah this works !!!one!!! !!50!!</p>\n`

### Customizing output

By default, emojis are rendered as appropriate unicode chars. But you can change
the renderer function as you wish.

Render as span blocks (for example, to use a custom iconic font):

```ruby
md = MarkdownIt::Parser.new
md.use(MotionMarkdownItPlugins::Emoji)
md.renderer.rules['emoji'] = lambda do |tokens, idx, _options, env, renderer|
  "<span class=\"emoji emoji_#{tokens[idx].markup}\"></span>"
end
```
