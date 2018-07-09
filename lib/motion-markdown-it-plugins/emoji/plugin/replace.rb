# Emojies & shortcuts replacement logic.
#
# Note: In theory, it could be faster to parse :smile: in inline chain and
# leave only shortcuts here. But, who care...
#------------------------------------------------------------------------------
module MotionMarkdownItPlugins
  module EmojiPlugin
    module Replace
      Z_RE_SRC  = UCMicro::Categories::Z::REGEX.source
      P_RE_SRC  = UCMicro::Categories::P::REGEX.source
      CC_RE_SRC = UCMicro::Categories::Cc::REGEX.source
      ZPCC_RE   = Regexp.new([Z_RE_SRC, P_RE_SRC, CC_RE_SRC].join('|'))

      #------------------------------------------------------------------------------
      def create_rule(md, emojies, shortcuts, scanRE, replaceRE)
        @emojies    = emojies
        @shortcuts  = shortcuts
        @scanRE     = scanRE
        @replaceRE  = replaceRE
        return lambda { |state| emoji_replace(state) }
      end

      #------------------------------------------------------------------------------
      def splitTextToken(text, level, token_class)
        last_pos  = 0
        nodes     = []

        text.gsub(@replaceRE) do |match|
          match_data  = Regexp.last_match
          offset      = match_data.offset(0)[0]
          src         = $'

          # Validate emoji name
          if @shortcuts.include?(match)
            # replace shortcut with full name
            emoji_name = @shortcuts[match]

            # Don't allow letters before any shortcut (as in no ":/" in http://)
            return if offset > 0 && !ZPCC_RE =~ src[offset - 1]

            # Don't allow letters after any shortcut
            return if (offset + match.length < src.length) && !ZPCC_RE =~ src[offset + match.length]
          else
            emoji_name = match.slice(1, match.length - 2)
          end

          # Add new tokens to pending list
          if offset > last_pos
            token         = token_class.new('text', '', 0)
            token.content = text.slice(last_pos, offset)
            nodes.push(token)
          end

          token         = token_class.new('emoji', '', 0)
          token.markup  = emoji_name
          token.content = @emojies[emoji_name]
          nodes.push(token)

          last_pos = offset + match.length
        end

        if last_pos < text.length
          token         = token_class.new('text', '', 0)
          token.content = text.slice(last_pos)
          nodes.push(token)
        end

        return nodes
      end

      #------------------------------------------------------------------------------
      def emoji_replace(state)
        blockTokens   = state.tokens
        autolinkLevel = 0

        0.upto(blockTokens.length - 1) do |j|
          next if blockTokens[j].type != 'inline'
          tokens = blockTokens[j].children

          # We scan from the end, to keep position when new tags added.
          # Use reversed logic in links start/end match
          (tokens.length - 1).downto(0) do |i|
            token = tokens[i]

            if token.type == 'link_open' || token.type == 'link_close'
              autolinkLevel -= token.nesting if token.info == 'auto'
            end

            if token.type == 'text' && autolinkLevel == 0 && @scanRE =~ token.content
              # replace current node
              blockTokens[j].children = tokens = arrayReplaceAt(
                tokens, i, splitTextToken(token.content, token.level, MarkdownIt::Token)
              )
            end
          end
        end
      end
    end
  end
end