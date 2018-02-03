# Process header sections
#
# Based on Javascript version: https://github.com/arve0/markdown-it-header-sections
#------------------------------------------------------------------------------

include MarkdownIt::Common::Utils

module MotionMarkdownItPlugins
  class HeaderSections

    def self.init_plugin(md, *options)
      headerSections = HeaderSections.new(md, options)
      md.core.ruler.push('header_sections', lambda { |state| headerSections.addSections(state) })
    end

    def initialize(md, options)
      reset
    end
    
    def reset()
      @tokens = []  # output
      @sections = []
      @nestedLevel = 0
    end

    def openSection(attrs)
      t = MarkdownIt::Token.new('section_open', 'section', 1)
      t.block = true
#     t.attrs = attrs && attrs.map(function (attr) { return [attr[0], attr[1]] })  # copy
      return t
    end

    def closeSection()
      t = MarkdownIt::Token.new('section_close', 'section', -1)
      t.block = true
      return t
    end

    def closeSections(section)
      while (@sections.last && section[:header] <= @sections.last[:header])
        @sections.pop()
        @tokens.push(closeSection())
      end
    end

    def closeAllSections()
      while (@sections.pop())
        @tokens.push(closeSection())
      end
    end

    def closeSectionsToCurrentNesting(nesting)
      while (@sections.last && nesting < @sections.last[:nesting])
        @sections.pop()
        @tokens.push(closeSection())
      end
    end

    def addSections(state)
      state.tokens.each do |token|
        # record level of nesting
        if (!token.type.start_with?('heading'))
          @nestedLevel += token.nesting
        end
        if (@sections.last && @nestedLevel < @sections.last[:nesting])
          closeSectionsToCurrentNesting(@nestedLevel)
        end

        # add sections before headers
        if (token.type == 'heading_open')
          section = {
            :header => token.tag[1,1].to_i,
            :nesting => @nestedLevel
          }
          if (@sections.last && section[:header] <= @sections.last[:header])
            closeSections(section)
          end
          @tokens.push(openSection(token.attrs))
          if (token.attrIndex('id') != -1)
            # remove ID from token
            token.attrs.splice(token.attrIndex('id'), 1)
          end
          @sections.push(section)
        end

        @tokens.push(token)
      end  # end for every token

      closeAllSections()

      state.tokens = @tokens
      reset
    end

  end

end
