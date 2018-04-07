# Process block-level custom containers
#
# Based on Javascript version: https://github.com/markdown-it/markdown-it-container
#------------------------------------------------------------------------------

module MotionMarkdownItPlugins
  class Container
    extend MarkdownIt::Common::Utils

    attr_accessor   :render

    #------------------------------------------------------------------------------
    def self.init_plugin(md, name, options = {})
      container_obj = Container.new(md, name, options)
      md.block.ruler.before('fence', "container_#{name}",
          lambda { |state, startLine, endLine, silent| container_obj.container(state, startLine, endLine, silent) },
          {alt: [ '', 'paragraph', 'reference', 'blockquote', 'list' ]})

      md.renderer.rules["container_#{name}_open"]  = container_obj.render
      md.renderer.rules["container_#{name}_close"] = container_obj.render
    end

    #------------------------------------------------------------------------------
    def initialize(md, name, options)
      @options     = options || {}
      @name        = name
      @min_markers = 3
      @marker_str  = @options[:marker] || ':'
      @marker_char = @marker_str.charCodeAt(0)
      @marker_len  = @marker_str.length
      @validate    = @options[:validate] || lambda {|params| validateDefault(params) }
      @render      = @options[:render]   || lambda {|tokens, idx, _options, env, renderer| renderDefault(tokens, idx, _options, env, renderer) }
    end

    #------------------------------------------------------------------------------
    def validateDefault(params)
      return params.strip.split(' ', 2)[0] == @name
    end

    #------------------------------------------------------------------------------
    def renderDefault(tokens, idx, _options, env, renderer)

      # add a class to the opening tag
      if (tokens[idx].nesting == 1)
        tokens[idx].attrPush([ 'class', @name ])
      end

      return renderer.renderToken(tokens, idx, _options, env, renderer)
    end

    #------------------------------------------------------------------------------
    def container(state, startLine, endLine, silent)
      auto_closed = false
      start       = state.bMarks[startLine] + state.tShift[startLine]
      max         = state.eMarks[startLine]

      # Check out the first character quickly,
      # this should filter out most of non-containers
      return false if (@marker_char != state.src.charCodeAt(start))

      # Check out the rest of the marker string
      pos = start + 1
      while pos <= max
        break if (@marker_str[(pos - start) % @marker_len] != state.src[pos])
        pos += 1
      end

      marker_count = ((pos - start) / @marker_len).floor
      return false if (marker_count < @min_markers)
      pos -= (pos - start) % @marker_len

      markup = state.src.slice(start...pos)
      params = state.src.slice(pos...max)

      return false if (!@validate.call(params))

      # Since start is found, we can report success here in validation mode
      return true if (silent)

      # Search for the end of the block
      nextLine = startLine

      while true
        nextLine += 1
        if (nextLine >= endLine)
          # unclosed block should be autoclosed by end of document.
          # also block seems to be autoclosed by end of parent
          break
        end

        start = state.bMarks[nextLine] + state.tShift[nextLine]
        max   = state.eMarks[nextLine]

        if (start < max && state.sCount[nextLine] < state.blkIndent)
          # non-empty line with negative indent should stop the list:
          # - ```
          #  test
          break
        end

        next if (@marker_char != state.src.charCodeAt(start))

        if (state.sCount[nextLine] - state.blkIndent >= 4)
          # closing fence should be indented less than 4 spaces
          next
        end

        pos = start + 1
        while pos <= max
          break if (@marker_str[(pos - start) % @marker_len] != state.src[pos])
          pos += 1
        end

        # closing code fence must be at least as long as the opening one
        next if (((pos - start).floor / @marker_len) < marker_count)

        # make sure tail has spaces only
        pos -= (pos - start) % @marker_len
        pos  = state.skipSpaces(pos)

        next if (pos < max)

        # found!
        auto_closed = true
        break
      end

      old_parent       = state.parentType
      old_line_max     = state.lineMax
      state.parentType = 'container'

      # this will prevent lazy continuations from ever going past our end marker
      state.lineMax = nextLine

      token        = state.push("container_#{@name}_open", 'div', 1)
      token.markup = markup
      token.block  = true
      token.info   = params
      token.map    = [ startLine, nextLine ]

      state.md.block.tokenize(state, startLine + 1, nextLine)

      token        = state.push("container_#{@name}_close", 'div', -1)
      token.markup = state.src.slice(start...pos)
      token.block  = true

      state.parentType = old_parent
      state.lineMax    = old_line_max
      state.line       = nextLine + (auto_closed ? 1 : 0)

      return true
    end

  end
end
