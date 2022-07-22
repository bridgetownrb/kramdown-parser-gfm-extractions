require "rouge"

module Rouge
  module Formatters
    class HTMLLineHighligherDelegator < Rouge::Formatters::HTMLLineHighlighter
      def initialize(opts)
        delegate = Rouge::Formatters::HTML.new
        super(delegate, opts)
      end
    end
  end
end
