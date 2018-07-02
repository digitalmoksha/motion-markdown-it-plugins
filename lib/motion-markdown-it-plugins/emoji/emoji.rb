# Based on Javascript version: https://github.com/markdown-it/markdown-it-emoji
#------------------------------------------------------------------------------

module MotionMarkdownItPlugins
  class Emoji
    extend MarkdownIt::Common::Utils

    attr_accessor   :render

    #------------------------------------------------------------------------------
    def self.init_plugin(md, options = {})
      emoji_obj = Emoji.new(md, options)
    end

    #------------------------------------------------------------------------------
    def initialize(md, options)
      defaults = {defs: {}, enabled: [], shortcuts: {}}
      @data    = :light
      @options = defaults.merge(options)
    end

  end
end
