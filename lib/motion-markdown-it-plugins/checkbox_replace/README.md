# markdown-it-checkbox

> Plugin to create checkboxes for [motion-markdown-it](https://github.com/digitalmoksha/motion-markdown-it) markdown parser.

_Ported from the [javascript version](https://github.com/mcecot/markdown-it-checkbox). Synced with v1.1.0.  Works with Ruby and RubyMotion._


This plugin allows to create checkboxes for tasklists as discussed [here](http://talk.commonmark.org/t/task-lists-in-standard-markdown/41).

## Usage

```ruby
md = MarkdownIt::Parser.new.use(MotionMarkdownItPlugins::CheckboxReplace)
md.render('[ ] unchecked')

# <p>
#  <input type="checkbox" id="checkbox0">
#  <label for="checkbox0">unchecked</label>
# </p>

md.render('[x] checked')
# <p>
#  <input type="checkbox" id="checkbox0" checked="true">
#  <label for="checkbox0">checked</label>
# </p>
```

### Options

```ruby
md = MarkdownIt::Parser.new.use(MotionMarkdownItPlugins::CheckboxReplace,
        {divWrap: true, divClass: 'cb', idPrefix: 'cbx_'})

md.render('[ ] unchecked')

# <p>
#  <div classname="cb">
#    <input type="checkbox" id="cbx_0">
#    <label for="cbx_0">unchecked</label>
#  </div>
# </p>
```

#### divWrap

* **Type:** `Boolean`
* **Default:** `false`

wrap div around checkbox. This makes it possible to use it for example with [Awesome Bootstrap Checkbox](https://github.com/flatlogic/awesome-bootstrap-checkbox/).

#### divClass

* **Type:** `String`
* **Default:** `checkbox`

class name of div wrapper. Will only be used if `divWrap` is enanbled.

#### idPrefix

* **Type:** `String`
* **Default:** `checkbox`

the id of the checkboxes.  Input will contain the prefix and an incremental number starting with `0`. i.e. `checkbox1` for the 2nd checkbox.
