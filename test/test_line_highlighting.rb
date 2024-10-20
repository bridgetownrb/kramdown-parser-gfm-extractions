require "minitest/autorun"

require "kramdown"
require "kramdown-parser-gfm-extractions"

class TestLineHighlighting < Minitest::Test
  def setup
    @text = <<~MD
        # Regular Markdown Here

        ```bash
        ls unhighlighted_dir
        ```

        ```ruby{2-4,6,8}
        class LineHighlighting
          def highlighted_method
            "this is all highlighted"
          end

          def partial_highlight
            "this line is not highlighted"
          end
        end
        ```

        *More Markdown continues...*

        ```javascript{1-3}
        highlighted = function() {
          "this can be highlighted as well";
        }
        ```
    MD
  end

  def test_correct_output
    doc = Kramdown::Document.new(
      @text,
      {
        input: :GFMExtractions,
        syntax_highlighter_opts:  {
          block: { formatter: "HTMLLineHighligherDelegator" },
        },
      }
    )
    html = doc.to_html
    assert html.scan("hll").size == 8
  end
end

