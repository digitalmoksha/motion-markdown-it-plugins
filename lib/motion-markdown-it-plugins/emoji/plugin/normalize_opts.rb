module MotionMarkdownItPlugins
  module EmojiPlugin
    module NormalizeOpts
      #------------------------------------------------------------------------------
      def quoteRE(str)
        str.gsub(/([.?*+^$\[\]\\(){}|-])/, '\\\\\1')
      end

      #------------------------------------------------------------------------------
      def normalize_opts(options)
        emojies   = stringify_keys(options[:defs])
        shortcuts = stringify_keys(options[:shortcuts])

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
        shortcuts = shortcuts.keys.reduce({}) do |acc, key|
          # Skip aliases for filtered emojies, to reduce regexp
          next acc if !emojies[key]

          if shortcuts[key].is_a?(Array)
            shortcuts[key].each do |alias_value|
              acc[alias_value] = key
            end
            next acc
          end

          acc[shortcuts[key]] = key
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

      private

      # convert keys from symbols into strings
      #------------------------------------------------------------------------------
      def stringify_keys(symbol_hash)
        result = {}
        symbol_hash.each_key { |key| result[key.to_s] = symbol_hash[key] }
        result
      end
    end
  end
end