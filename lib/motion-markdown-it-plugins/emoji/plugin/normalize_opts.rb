module MotionMarkdownItPlugins
  module EmojiPlugin
    module NormalizeOpts
      #------------------------------------------------------------------------------
      def quoteRE(str)
        str.gsub(/([.?*+^$\[\]\\(){}|-])/, '\\\\\1')
      end

      #------------------------------------------------------------------------------
      def normalize_opts(options)
        emojies = options[:defs]

        # Filter emojies by whitelist, if needed
        if options[:enabled].length > 0
          emojies = emojies.keys.reduce({}) do |acc, key|
            if options[:enabled].include?(key)
              acc[key] = emojies[key]
            end

            acc
          end
        end

        # Flatten shortcuts to simple object: { alias: emoji_name }
        shortcuts = options[:shortcuts].keys.reduce({}) do |acc, key|
          # Skip aliases for filtered emojies, to reduce regexp
          next acc if !emojies[key]

          if options[:shortcuts][key].is_a?(Array)
            options[:shortcuts][key].each do |alias_value|
              acc[alias_value] = key
            end
            next acc
          end

          acc[options[:shortcuts][key]] = key
          acc
        end

        # Compile regexp
        names = emojies.keys
                      .map { |name| ':' + name + ':' }
                      .concat(shortcuts.keys)
                      .sort
                      .reverse
                      .map { |name| quoteRE(name) }
                      .join('|')

        scanRE    = Regexp.new(names)
        replaceRE = Regexp.new(names)

        return {
          defs:       emojies,
          shortcuts:  shortcuts,
          scanRE:     scanRE,
          replaceRE:  replaceRE
        }
      end
    end
  end
end