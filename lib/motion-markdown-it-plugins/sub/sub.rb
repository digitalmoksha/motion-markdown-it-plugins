# Process ~subscript~
#
# Based on Javascript version: https://github.com/markdown-it/markdown-it-sub
#------------------------------------------------------------------------------

module MotionMarkdownItPlugins
  class Sub
    extend MarkdownIt::Common::Utils

    # same as UNESCAPE_MD_RE plus a space
    UNESCAPE_RE = /\\([ \!\"\#\$\%\&\'\(\)\*\+\,\-.\/:;<=>?@\[\\\]^_`{|}~])/

    #------------------------------------------------------------------------------
    def self.init_plugin(md)
      md.inline.ruler.after('emphasis', 'sub', lambda { |state, silent| Sub.subscript(state, silent) })
    end

    #------------------------------------------------------------------------------
    def self.subscript(state, silent)
      max   = state.posMax
      start = state.pos

      return false if (state.src.charCodeAt(start) != 0x7E)  # '~'
      return false if (silent) # don't run any pairs in validation mode
      return false if (start + 2 >= max)

      state.pos = start + 1

      while (state.pos < max)
        if (state.src.charCodeAt(state.pos) == 0x7E)  # '~'
          found = true
          break
        end

        state.md.inline.skipToken(state)
      end

      if (!found || start + 1 == state.pos)
        state.pos = start
        return false
      end

      content = state.src.slice((start + 1)...state.pos)

      # don't allow unescaped spaces/newlines inside
      if (content.match(/(^|[^\\])(\\\\)*\s/))
        state.pos = start
        return false
      end

      # found!
      state.posMax = state.pos
      state.pos    = start + 1

      # Earlier we checked !silent, but this implementation does not need it
      token         = state.push('sub_open', 'sub', 1)
      token.markup  = '~'

      token         = state.push('text', '', 0)
      token.content = content.gsub(UNESCAPE_RE, '\1')

      token         = state.push('sub_close', 'sub', -1)
      token.markup  = '~'

      state.pos    = state.posMax + 1
      state.posMax = max
      return true
    end
  end
end
