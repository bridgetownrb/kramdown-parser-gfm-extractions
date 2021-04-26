require "minitest/autorun"

require "kramdown"
require "kramdown-parser-gfm-extractions"

class TestKramdownOutput < Minitest::Test
  def setup
    @text = <<~MD
      Hello **folks**

      ```js script
      import "Foo" from "./bar.js"
      ```

      ```ruby
      a = 1 + 2
      ```

      ```html preview-story
      <p>I'm a preview!</p>
      ```

      This is _Markdown!_
    MD
  end

  def test_correct_output
    doc = Kramdown::Document.new(@text, {input: :GFMExtractions})
    html = doc.to_html
    extractions = doc.root.options[:extractions]

    assert_includes html, "<kramdown-extraction id=\"ex-2289e1a3b2a683414ac1f73fac73dabf109a1967914702f059c5f1503cdc4b2c\" lang=\"js\" meta=\"script\"><template>    <div class=\"language-js highlighter-rouge\"><div class=\"highlight\"><pre class=\"highlight\"><code><span class=\"k\">import</span> <span class=\"dl\">\"</span><span class=\"s2\">Foo</span><span class=\"dl\">\"</span> <span class=\"k\">from</span> <span class=\"dl\">\"</span><span class=\"s2\">./bar.js</span><span class=\"dl\">\"</span>\n</code></pre></div>    </div>\n</template></kramdown-extraction>"
    assert_includes html, "<div class=\"language-ruby highlighter-rouge\"><div class=\"highlight\"><pre class=\"highlight\"><code><span class=\"n\">a</span> <span class=\"o\">=</span> <span class=\"mi\">1</span> <span class=\"o\">+</span> <span class=\"mi\">2</span>\n</code></pre></div></div>"

    assert_equal 2, extractions.length
    assert_equal "js", extractions[0][:lang]
    assert_equal "script", extractions[0][:meta]
    assert_includes extractions[0][:code], 'import "Foo" from "./bar.js"'
  end
end

