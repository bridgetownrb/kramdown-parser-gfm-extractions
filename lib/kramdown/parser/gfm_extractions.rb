require "kramdown/parser/gfm"
require "digest/sha2"

module Kramdown
  module Parser
    class GFMExtractions < Kramdown::Parser::GFM
      FENCED_CODEBLOCK_MATCH = /^[ ]{0,3}(([~`]){3,})\s*?((.+?)(?:\?\S*)?)?\s*?\n(.*?)^[ ]{0,3}\1\2*\s*?\n/m.freeze

      def parse_codeblock_fenced
        if @src.check(FENCED_CODEBLOCK_MATCH) && @src[3].to_s.strip.include?(" ")
          @src.pos += @src.matched_size
          lang = @src[3].to_s.strip
          lang = lang.split(" ")

          sha = Digest::SHA2.hexdigest(@src[5])
          @root.options[:extractions] ||= []
          @root.options[:extractions] << {
            sha: sha,
            lang: lang[0],
            meta: lang[1],
            code: @src[5]
          }

          start_line_number = @src.current_line_number

          unless options[:include_extraction_tags] == false
            el = Element.new(:html_element, "kramdown-extraction", {id: "ex-#{sha}", lang: lang[0], meta: lang[1]}, category: :block, location: start_line_number, content_model: :raw)

            unless options[:include_code_in_extractions] == false
              code_el = new_block_el(:codeblock, @src[5], nil, location: start_line_number, fenced: true)
              code_el.options[:lang] = lang[0]
              code_el.attr['class'] = "language-#{lang[0]}"
              el.children << Element.new(:html_element, "template", nil, category: :block, location: start_line_number, content_model: :raw).tap do |tmpl|
                tmpl.children << code_el
              end
            end

            @tree.children << el
          end

          true
        else
          super
        end
      end
    end
  end
end