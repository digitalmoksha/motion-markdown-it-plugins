# Process definition lists
#
# Based on Javascript version: https://github.com/markdown-it/markdown-it-deflist
#------------------------------------------------------------------------------
include MarkdownIt::Common::Utils

module MotionMarkdownItPlugins
  class Deflist

    #------------------------------------------------------------------------------
    def self.init_plugin(md)
      md.block.ruler.before('paragraph', 'deflist', 
          lambda { |state, startLine, endLine, silent| Deflist.deflist(state, startLine, endLine, silent) },
          {alt: ['', 'paragraph', 'reference']})
    end

    # Search `[:~][\n ]`, returns next pos after marker on success
    # or -1 on fail.
    #------------------------------------------------------------------------------
    def self.skipMarker(state, line)
      start = state.bMarks[line] + state.tShift[line]
      max   = state.eMarks[line]

      return -1 if (start >= max)

      # Check bullet
      marker = state.src.charCodeAt(start)
      start += 1
      return -1 if (marker != 0x7E && marker != 0x3A) #  '~'  ':'

      pos = state.skipSpaces(start)

      # require space after ":"
      return -1 if (start == pos)

      # no empty definitions, e.g. "  : "
      return -1 if (pos >= max)

      return pos
    end

    #------------------------------------------------------------------------------
    def self.markTightParagraphs(state, idx)
      level = state.level + 2
      i     = idx + 2
      l     = state.tokens.length - 2
      while i < l
        if (state.tokens[i].level == level && state.tokens[i].type == 'paragraph_open')
          state.tokens[i + 2].hidden = true
          state.tokens[i].hidden     = true
          i += 2
        end
        i += 1
      end
    end

    #------------------------------------------------------------------------------
    def self.deflist(state, startLine, endLine, silent)
      if silent
        # quirk: validation mode validates a dd block only, not a whole deflist
        return false if (state.ddIndent < 0)
        return skipMarker(state, startLine) >= 0
      end

      nextLine = startLine + 1
      if (state.isEmpty(nextLine))
        nextLine += 1
        return false if (nextLine > endLine)
      end

      return false if (state.tShift[nextLine] < state.blkIndent)
      contentStart = skipMarker(state, nextLine)
      return false if (contentStart < 0)

      # Start list
      listTokIdx = state.tokens.length
      token      = state.push('dl_open', 'dl', 1)
      token.map  = listLines = [ startLine, 0 ]

      #--- Iterate list items

      dtLine = startLine
      ddLine = nextLine

      # One definition list can contain multiple DTs,
      # and one DT can be followed by multiple DDs.
      #
      # Thus, there is two loops here, and label is
      # needed to break out of the second one
      # OUTER:
      while true
        break_outer    = false
        tight          = true
        prevEmptyEnd   = false

        token          = state.push('dt_open', 'dt', 1)
        token.map      = [ dtLine, dtLine ]

        token          = state.push('inline', '', 0)
        token.map      = [ dtLine, dtLine ]
        token.content  = state.getLines(dtLine, dtLine + 1, state.blkIndent, false).strip
        token.children = []

        token          = state.push('dt_close', 'dt', -1)

        while true
          token     = state.push('dd_open', 'dd', 1)
          token.map = itemLines = [ nextLine, 0 ]

          oldTight             = state.tight
          oldDDIndent          = state.ddIndent
          oldIndent            = state.blkIndent
          oldTShift            = state.tShift[ddLine]
          oldParentType        = state.parentType
          state.blkIndent      = state.ddIndent = state.tShift[ddLine] + 2
          state.tShift[ddLine] = contentStart - state.bMarks[ddLine]
          state.tight          = true
          state.parentType     = 'deflist'

          state.md.block.tokenize(state, ddLine, endLine, true)

          # If any of list item is tight, mark list as tight
          if (!state.tight || prevEmptyEnd)
            tight = false
          end
          # Item become loose if finish with empty line,
          # but we should filter last element, because it means list finish
          prevEmptyEnd = (state.line - ddLine) > 1 && state.isEmpty(state.line - 1)

          state.tShift[ddLine] = oldTShift
          state.tight          = oldTight
          state.parentType     = oldParentType
          state.blkIndent      = oldIndent
          state.ddIndent       = oldDDIndent

          token = state.push('dd_close', 'dd', -1)

          itemLines[1] = nextLine = state.line

          break_outer = true and break if (nextLine >= endLine)
          break_outer = true and break if (state.tShift[nextLine] < state.blkIndent)
          contentStart = skipMarker(state, nextLine)
          break if (contentStart < 0)

          ddLine = nextLine

          # go to the next loop iteration:
          # insert DD tag and repeat checking
        end
        break if break_outer
        
        break if (nextLine >= endLine)
        dtLine = nextLine

        break if (state.isEmpty(dtLine))
        break if (state.tShift[dtLine] < state.blkIndent)

        ddLine = dtLine + 1
        break if (ddLine >= endLine)
        ddLine += 1 if (state.isEmpty(ddLine))
        break if (ddLine >= endLine)

        break if (state.tShift[ddLine] < state.blkIndent)
        contentStart = skipMarker(state, ddLine)
        break if (contentStart < 0)

        # go to the next loop iteration:
        # insert DT and DD tags and repeat checking
      end

      # Finilize list
      token        = state.push('dl_close', 'dl', -1)
      listLines[1] = nextLine
      state.line   = nextLine

      # mark paragraphs tight if needed
      if (tight)
        markTightParagraphs(state, listTokIdx)
      end

      return true
    end

  end
end
