module MotionMarkdownItPlugins
  module EmojiPlugin
    module Render
      def emoji_html(tokens, idx) #, options, env
        return tokens[idx].content
      end
    end
  end
end