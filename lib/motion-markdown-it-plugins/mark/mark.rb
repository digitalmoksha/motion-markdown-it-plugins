# Based on Javascript version: https://github.com/markdown-it/markdown-it-mark
#------------------------------------------------------------------------------

module MotionMarkdownItPlugins
  class Mark
    extend MarkdownIt::Common::Utils

    #------------------------------------------------------------------------------
    def self.init_plugin(md)
      md.inline.ruler.before('emphasis', 'mark', lambda { |state, silent| Mark.tokenize(state, silent) })
      md.inline.ruler2.before('emphasis', 'mark', lambda { |state| Mark.postProcess(state) })
    end

    # Insert each marker as a separate text token, and add it to delimiter list
    #------------------------------------------------------------------------------
    def self.tokenize(state, silent)
      start  = state.pos
      marker = charCodeAt(state.src, start)

      return false if silent

      return false if marker != 0x3D # =

      scanned = state.scanDelims(state.pos, true)
      len = scanned[:length]
      ch  = fromCharCode(marker)

      return false if len < 2

      if len % 2 > 0
        token         = state.push('text', '', 0)
        token.content = ch
        len -= 1
      end

      i = 0
      while i < len
        token         = state.push('text', '', 0)
        token.content = ch + ch

        state.delimiters.push({
          marker: marker,
          length: scanned[:length],
          jump:   i,
          token:  state.tokens.length - 1,
          level:  state.level,
          end:    -1,
          open:   scanned[:can_open],
          close:  scanned[:can_close]
        })

        i += 2
      end

      state.pos += scanned[:length]

      return true
    end

    # Walk through delimiter list and replace text tokens with tags
    #------------------------------------------------------------------------------
    def self.postProcess(state)
      loneMarkers = []
      delimiters  = state.delimiters
      max         = state.delimiters.length

      i = 0
      while i < max
        startDelim = delimiters[i]

        (i += 1) and next if startDelim[:marker] != 0x3D # =

        (i += 1) and next if startDelim[:end] == -1

        endDelim = delimiters[startDelim[:end]]

        token         = state.tokens[startDelim[:token]]
        token.type    = 'mark_open'
        token.tag     = 'mark'
        token.nesting = 1
        token.markup  = '=='
        token.content = ''

        token         = state.tokens[endDelim[:token]]
        token.type    = 'mark_close'
        token.tag     = 'mark'
        token.nesting = -1
        token.markup  = '=='
        token.content = ''

        if (state.tokens[endDelim[:token] - 1].type == 'text' &&
            state.tokens[endDelim[:token] - 1].content == '=')
          loneMarkers.push(endDelim[:token] - 1)
        end

        i += 1
      end

      # If a marker sequence has an odd number of characters, it's splitted
      # like this: `~~~~~` -> `~` + `~~` + `~~`, leaving one marker at the
      # start of the sequence.
      #
      # So, we have to move all those markers after subsequent s_close tags.
      #
      while loneMarkers.length > 0
        i = loneMarkers.pop
        j = i + 1

        while j < state.tokens.length && state.tokens[j].type === 'mark_close'
          j += 1
        end

        j -= 1

        if i != j
          token = state.tokens[j]
          state.tokens[j] = state.tokens[i]
          state.tokens[i] = token
        end
      end
    end
  end
end
