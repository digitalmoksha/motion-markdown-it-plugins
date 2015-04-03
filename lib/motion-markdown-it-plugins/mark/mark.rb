# Based on Javascript version: https://github.com/markdown-it/markdown-it-mark
#------------------------------------------------------------------------------

module MotionMarkdownItPlugins
  class Mark
    extend MarkdownIt::Common::Utils

    #------------------------------------------------------------------------------
    def self.init_plugin(md)
      md.inline.ruler.before('emphasis', 'mark', lambda { |state, silent| Mark.mark(state, silent) })
    end

    # parse sequence of markers,
    # "start" should point at a valid marker
    #------------------------------------------------------------------------------
    def self.scanDelims(state, start)
      pos            = start
      can_open       = true
      can_close      = true
      max            = state.posMax
      marker         = state.src.charCodeAt(start)

      # treat beginning of the line as a whitespace
      lastChar = start > 0 ? state.src.charCodeAt(start - 1) : 0x20

      while (pos < max && state.src.charCodeAt(pos) == marker)
        pos += 1
      end

      if (pos >= max)
        can_open = false
      end

      count = pos - start

      # treat end of the line as a whitespace
      nextChar = pos < max ? state.src.charCodeAt(pos) : 0x20

      isLastPunctChar = isMdAsciiPunct(lastChar) || isPunctChar(lastChar.chr(Encoding::UTF_8))
      isNextPunctChar = isMdAsciiPunct(nextChar) || isPunctChar(nextChar.chr(Encoding::UTF_8))

      isLastWhiteSpace = isWhiteSpace(lastChar)
      isNextWhiteSpace = isWhiteSpace(nextChar)

      if (isNextWhiteSpace)
        can_open = false
      elsif (isNextPunctChar)
        if (!(isLastWhiteSpace || isLastPunctChar))
          can_open = false
        end
      end

      if (isLastWhiteSpace)
        can_close = false
      elsif (isLastPunctChar)
        if (!(isNextWhiteSpace || isNextPunctChar))
          can_close = false
        end
      end

      return {can_open: can_open, can_close: can_close, delims: count}
    end

    #------------------------------------------------------------------------------
    def self.mark(state, silent)
      max    = state.posMax
      start  = state.pos
      marker = state.src.charCodeAt(start)

      return false if (marker != 0x3D) #  '='
      return false if (silent) # don't run any pairs in validation mode

      res = scanDelims(state, start)
      startCount = res[:delims]

      if (!res[:can_open])
        state.pos += startCount
        # Earlier we checked !silent, but this implementation does not need it
        state.pending += state.src.slice(start...state.pos)
        return true
      end

      stack = (startCount / 2).floor
      return false if (stack <= 0)
      state.pos = start + startCount

      while (state.pos < max)
        if (state.src.charCodeAt(state.pos) == marker)
          res   = scanDelims(state, state.pos)
          count = res[:delims]
          tagCount = (count / 2).floor
          if (res[:can_close])
            if (tagCount >= stack)
              state.pos += count - 2
              found = true
              break
            end
            stack     -= tagCount
            state.pos += count
            next
          end

          stack     += tagCount if (res[:can_open])
          state.pos += count
          next
        end

        state.md.inline.skipToken(state)
      end

      if (!found)
        # parser failed to find ending tag, so it's not valid emphasis
        state.pos = start
        return false
      end

      # found!
      state.posMax = state.pos
      state.pos    = start + 2

      # Earlier we checked !silent, but this implementation does not need it
      token        = state.push('mark_open', 'mark', 1)
      token.markup = marker.chr * 2

      state.md.inline.tokenize(state)

      token        = state.push('mark_close', 'mark', -1)
      token.markup = marker.chr * 2

      state.pos    = state.posMax + 2
      state.posMax = max
      return true
    end

  end
end