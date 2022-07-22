require "kramdown/parser/gfm"
require "digest/sha2"

module Kramdown
  module Parser
    class GFMExtractions < Kramdown::Parser::GFM
      FENCED_CODEBLOCK_MATCH = /^[ ]{0,3}(([~`]){3,})\s*?((.+?)(?:\?\S*)?)?\s*?\n(.*?)^[ ]{0,3}\1\2*\s*?\n/m.freeze
      LINE_NUMBER_MATCH = /(?<lang>\w+){(?<line_numbers>[\d,-]+)}$/

      def parse_codeblock_fenced
        @root.options[:line_numbers] ||= []
        if @src.check(FENCED_CODEBLOCK_MATCH)
          if match = @src[3].match(LINE_NUMBER_MATCH)
            extract_line_numbers(match)
          elsif @src[3].to_s.strip.include?(" ")
            extract_mdjs
          else
            @root.options[:line_numbers] << []
            super
          end
        end
      end

      def extract_line_numbers(match)
        line_number_groups = match[:line_numbers].split(",").map(&:strip)
        line_numbers = line_number_groups.reduce([]) do |memo, line_number_group|
          if range = line_number_group.match(/(\d+)-(\d+)/)
            memo += (range[1].to_i..range[2].to_i).to_a
          else
            memo << line_number_group.to_i
          end
        end
        start_line_number = @src.current_line_number
        @src.pos += @src.matched_size
        el = new_block_el(:codeblock, @src[5], nil, location: start_line_number, fenced: true)
        lang = match[:lang]
        unless lang.empty?
          el.options[:lang] = lang
          el.attr['class'] = "language-#{lang}"
        end
        @tree.children << el
        @root.options[:line_numbers] << line_numbers
        true
      end

      def extract_mdjs
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
          @root.options[:line_numbers] << []
          true
        end
      end
    end
  end
end
