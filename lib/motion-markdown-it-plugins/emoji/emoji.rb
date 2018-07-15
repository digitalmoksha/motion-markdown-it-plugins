# Based on Javascript version: https://github.com/markdown-it/markdown-it-emoji
#------------------------------------------------------------------------------
module MotionMarkdownItPlugins
  class Emoji
    extend  MarkdownIt::Common::Utils
    include MotionMarkdownItPlugins::EmojiPlugin::Render
    include MotionMarkdownItPlugins::EmojiPlugin::Replace
    include MotionMarkdownItPlugins::EmojiPlugin::NormalizeOpts
    include MotionMarkdownItPlugins::EmojiPlugin::Data::Full
    include MotionMarkdownItPlugins::EmojiPlugin::Data::Shortcuts

    attr_accessor   :render

    #------------------------------------------------------------------------------
    def self.init_plugin(md, options = {})
      emoji_obj = Emoji.new(md, options)
      md.renderer.rules['emoji'] = emoji_obj.render
    end

    #------------------------------------------------------------------------------
    def initialize(md, options)
      defaults = {defs: emojies_defs, enabled: [], shortcuts: EMOJIES_DEF_SHORTCUTS}
      @render  = lambda {|tokens, idx, _options, env, renderer| emoji_html(tokens, idx) }
      @options = normalize_opts(assign({}, defaults, options || {}))

      md.core.ruler.push('emoji', create_rule(md, @options[:defs], @options[:shortcuts], @options[:scanRE], @options[:replaceRE]))
    end

    #------------------------------------------------------------------------------
    def emojies_defs
      EMOJIES_DEF_FULL
    end
  end
end
