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
        return lambda { |state| emoji_replace(state) }
      end

      #------------------------------------------------------------------------------
      def splitTextToken(text, level, token_class)
        #     var token, last_pos = 0, nodes = [];
        #
        #     text.replace(replaceRE, function (match, offset, src) {
        #       var emoji_name;
        #       // Validate emoji name
        #       if (shortcuts.hasOwnProperty(match)) {
        #         // replace shortcut with full name
        #         emoji_name = shortcuts[match];
        #
        #         // Don't allow letters before any shortcut (as in no ":/" in http://)
        #         if (offset > 0 && !ZPCC_RE.test(src[offset - 1])) {
        #           return;
        #         }
        #
        #         // Don't allow letters after any shortcut
        #         if (offset + match.length < src.length && !ZPCC_RE.test(src[offset + match.length])) {
        #           return;
        #         }
        #       } else {
        #         emoji_name = match.slice(1, -1);
        #       }
        #
        #       // Add new tokens to pending list
        #       if (offset > last_pos) {
        #         token         = new token_class('text', '', 0);
        #         token.content = text.slice(last_pos, offset);
        #         nodes.push(token);
        #       }
        #
        #       token         = new token_class('emoji', '', 0);
        #       token.markup  = emoji_name;
        #       token.content = emojies[emoji_name];
        #       nodes.push(token);
        #
        #       last_pos = offset + match.length;
        #     });
        #
        #     if (last_pos < text.length) {
        #       token         = new token_class('text', '', 0);
        #       token.content = text.slice(last_pos);
        #       nodes.push(token);
        #     }
        #
        #     return nodes;
        #   }
      end

      #------------------------------------------------------------------------------
      def emoji_replace(state)
        #     var i, j, l, tokens, token,
        #         blockTokens = state.tokens,
        #         autolinkLevel = 0;
        #
        #     for (j = 0, l = blockTokens.length; j < l; j++) {
        #       if (blockTokens[j].type !== 'inline') { continue; }
        #       tokens = blockTokens[j].children;
        #
        #       // We scan from the end, to keep position when new tags added.
        #       // Use reversed logic in links start/end match
        #       for (i = tokens.length - 1; i >= 0; i--) {
        #         token = tokens[i];
        #
        #         if (token.type === 'link_open' || token.type === 'link_close') {
        #           if (token.info === 'auto') { autolinkLevel -= token.nesting; }
        #         }
        #
        #         if (token.type === 'text' && autolinkLevel === 0 && scanRE.test(token.content)) {
        #           // replace current node
        #           blockTokens[j].children = tokens = arrayReplaceAt(
        #             tokens, i, splitTextToken(token.content, token.level, state.Token)
        #           );
        #         }
        #       }
        #     }
        #   };
        # };
      end
    end
  end
end