# Based on Javascript version: https://github.com/markdown-it/markdown-it-emoji
#------------------------------------------------------------------------------
module MotionMarkdownItPlugins
  class EmojiLight < Emoji
    include MotionMarkdownItPlugins::EmojiPlugin::Data::Light

    #------------------------------------------------------------------------------
    def self.init_plugin(md, options = {})
      emoji_obj = EmojiLight.new(md, options)
      md.renderer.rules['emoji'] = emoji_obj.render
    end

    #------------------------------------------------------------------------------
    def emojies_defs
      EMOJIES_DEF_LIGHT
    end
  end
end
