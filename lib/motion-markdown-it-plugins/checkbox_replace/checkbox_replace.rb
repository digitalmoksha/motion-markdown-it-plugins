# Based on Javascript version: https://github.com/mcecot/markdown-it-checkbox
#------------------------------------------------------------------------------
include MarkdownIt::Common::Utils

module MotionMarkdownItPlugins
  class CheckboxReplace
    PATTERN = /\[(X|\s|\_|\-)\]\s(.*)/i
    
    #------------------------------------------------------------------------------
    def self.init_plugin(md, options)
      check = CheckboxReplace.new(md, options)
      md.core.ruler.push('checkbox', lambda { |state| check.checkbox(state) } )
    end

    #------------------------------------------------------------------------------
    def initialize(md, options)
      @lastId  = 0
      defaults = {divWrap: false, divClass: 'checkbox', idPrefix: 'checkbox'}
      @options = defaults.merge(options)
    end

    #------------------------------------------------------------------------------
    def createTokens(checked, label, original)
      nodes = []

      # <div class="checkbox">
      if @options[:divWrap]
        token = MarkdownIt::Token.new("checkbox_open", "div", 1)
        token.attrs = [["class", @options[:divClass]]]
        nodes.push token
      end

      # <input type="checkbox" id="checkbox{n}" checked="true">
      id          = "#{@options[:idPrefix]}#{@lastId}"
      @lastId    += 1
      token       = MarkdownIt::Token.new("checkbox_input", "input", 0)
      token.attrs = [["type","checkbox"],["id",id]]
      if (checked == true)
        token.attrs.push ["checked","true"]
      end
      nodes.push token

      # <label for="checkbox{n}">
      token       = MarkdownIt::Token.new("label_open", "label", 1)
      token.attrs = [["for",id]]
      nodes.push token

      # content of label tag
      token         = MarkdownIt::Token.new("text", "", 0)
      token.content = label
      original.children[0].content = label
      original.children.each {|tok| nodes.push tok}

      # closing tags
      nodes.push MarkdownIt::Token.new("label_close", "label", -1)
      if @options[:divWrap]
        nodes.push MarkdownIt::Token.new("checkbox_close", "div", -1)
      end

      original.children = nodes
      return original
    end
  
    # original should be an inline node.  it can only be a task item if the first 
    # child node has the right text
    #------------------------------------------------------------------------------
    def splitTextToken(original)

      if original.children
        first_node = original.children[0]
        if first_node
          text      = first_node.content
          matches   = text.match(PATTERN)

          return original if matches == nil

          value     = matches[1]
          label     = matches[2]
          checked   = false
          checked   = true if (value == "X" || value == "x")

          return createTokens(checked, label, original)
        end
      end
      return original
    end

    #------------------------------------------------------------------------------
    def checkbox(state)
      blockTokens = state.tokens
      j = 0
      l = blockTokens.length

      # blockTokens.each do |xtoken|
      #   puts "  " * xtoken.level + "#{xtoken.inspect}"
      # end
      
      while j < l
        if blockTokens[j].type != "inline"
          j += 1
          next
        end
        tokens = blockTokens[j].children
        
        # # We scan from the end, to keep position when new tags added.
        # # Use reversed logic in links start/end match
        # i = tokens.length - 1
        # while i >= 0
        #   token = tokens[i]
        #   blockTokens[j].children = tokens = arrayReplaceAt(tokens, i, splitTextToken(token))
        #   i -= 1
        # end

        token = blockTokens[j]
        arrayReplaceAt(blockTokens, j, splitTextToken(token))

        j += 1
      end
    end
  end
end

