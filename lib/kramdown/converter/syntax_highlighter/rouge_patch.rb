module Kramdown::Converter::SyntaxHighlighter
  module Rouge
    class << self
      alias_method :old_options, :options

      def options(converter, type)
        opts = self.old_options(converter, type)
        opts.merge(highlight_lines: converter.root.options[:line_numbers].shift)
      end
    end
  end
end
