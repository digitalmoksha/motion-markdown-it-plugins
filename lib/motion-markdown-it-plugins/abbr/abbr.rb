# Enclose abbreviations in <abbr> tags
#
# Based on Javascript version: https://github.com/markdown-it/markdown-it-abbr
#------------------------------------------------------------------------------
include MarkdownIt::Common::Utils

module MotionMarkdownItPlugins
  class Abbr
    # ASCII characters in Cc, Sc, Sm, Sk categories we should terminate on;
    # you can check character classes here:
    # http://www.unicode.org/Public/UNIDATA/UnicodeData.txt
    OTHER_CHARS         = ' \r\n$+<=>^`|~'
    OTHER_CHARS_ESCAPED = OTHER_CHARS.chars.map {|c| escapeRE(c)}.join

    UNICODE_PUNCT_RE = UCMicro::Categories::P::REGEX
    UNICODE_SPACE_RE = UCMicro::Categories::Z::REGEX

    #------------------------------------------------------------------------------
    def self.init_plugin(md)
      md.block.ruler.before('reference', 'abbr_def',
          lambda { |state, startLine, endLine, silent| Abbr.abbr_def(state, startLine, endLine, silent) },
          {alt: ['', 'paragraph', 'reference']})
      md.core.ruler.after('linkify', 'abbr_replace', lambda { |state| Abbr.abbr_replace(state) })
    end

    #------------------------------------------------------------------------------
    def self.abbr_def(state, startLine, endLine, silent)
      pos = state.bMarks[startLine] + state.tShift[startLine]
      max = state.eMarks[startLine]

      return false if (pos + 2 >= max)
      return false if charCodeAt(state.src, pos) != 0x2A  # '*'
      pos += 1
      return false if charCodeAt(state.src, pos) != 0x5B  # '['
      pos += 1

      labelStart = pos

      while pos < max
        ch = charCodeAt(state.src, pos)
        if (ch == 0x5B)  # '['
          return false
        elsif (ch == 0x5D)  #  ']'
          labelEnd = pos
          break
        elsif (ch == 0x5C)  #  '\'
          pos += 1
        end
        pos += 1
      end

      return false if (labelEnd.nil? || charCodeAt(state.src, labelEnd + 1) != 0x3A)  # ':'
      return true  if (silent)

      label = state.src.slice(labelStart...labelEnd).gsub(/\\(.)/, '\1')
      title = state.src.slice((labelEnd + 2)...max).strip
      return false if label.length == 0
      return false if title.length == 0

      state.env[:abbreviations] = {} if (!state.env[:abbreviations])
      state.env[:abbreviations][label] = title if state.env[:abbreviations][label].nil?

      state.line = startLine + 1
      return true
    end

    #------------------------------------------------------------------------------
    def self.abbr_replace(state)
      blockTokens = state.tokens

      return if (!state.env[:abbreviations])

      regSimpleText  = '(?:'
      regSimpleText << state.env[:abbreviations].keys.sort {|a, b| b.length <=> a.length}.map {|x| escapeRE(x)}.join('|')
      regSimpleText << ')'
      regSimple      = Regexp.new(regSimpleText)

      regText  = "(^|#{UNICODE_PUNCT_RE}|#{UNICODE_SPACE_RE}" +
                 "|[#{OTHER_CHARS_ESCAPED}])"
      regText << '(' + state.env[:abbreviations].keys.sort {|a, b| b.length <=> a.length}.map {|x| escapeRE(x)}.join('|') + ')'
      regText << "($|#{UNICODE_PUNCT_RE}|#{UNICODE_SPACE_RE}" +
                 "|[#{OTHER_CHARS_ESCAPED}])"

      reg = Regexp.new(regText)

      j = 0
      l = blockTokens.length
      while j < l
        j += 1 and next if (blockTokens[j].type != 'inline')
        tokens = blockTokens[j].children

        # We scan from the end, to keep position when new tags added.
        i = tokens.length - 1
        while i >= 0
          currentToken = tokens[i]
          i -= 1 and next if (currentToken.type != 'text')

          pos       = 0
          text      = currentToken.content
          lastIndex = 0
          nodes     = []

          # fast regexp run to determine whether there are any abbreviated words
          # in the current token
          i -= 1 and next if !(regSimple =~ text)

          while ((m = reg.match(text, lastIndex)))
            lastIndex = m.end(0)
            if m.begin(0) > 0 || m[1]
              token         = MarkdownIt::Token.new('text', '', 0)
              token.content = text.slice(pos...(m.begin(0) + m[1].length))
              nodes.push(token)
            end

            token         = MarkdownIt::Token.new('abbr_open', 'abbr', 1)
            token.attrs   = [ [ 'title', state.env[:abbreviations][m[2]] ] ]
            nodes.push(token)

            token         = MarkdownIt::Token.new('text', '', 0)
            token.content = m[2]
            nodes.push(token)

            token         = MarkdownIt::Token.new('abbr_close', 'abbr', -1)
            nodes.push(token)

            lastIndex -= m[3].length
            pos        = lastIndex
          end

          i -= 1 and next if nodes.empty?

          if (pos < text.length)
            token         = MarkdownIt::Token.new('text', '', 0)
            token.content = text.slice(pos..-1)
            nodes.push(token)
          end

          # replace current node
          blockTokens[j].children = tokens = arrayReplaceAt(tokens, i, nodes)
          i -= 1
        end
        j += 1
      end
    end

  end
end