# kramdown-parser-gfm-extractions

> [!WARNING]
> This plugin is considered "as-is" and I don't anticpate developing it any further. If you submit an interesting PR, I'm willing to merge it, but otherwise…it's done.

----

A [Kramdown](https://kramdown.gettalong.org) parser extension which provides support for extracting fenced code blocks featuring meta (for example `js script` or `html preview-story`). Useful for supporting the [Markdown JavaScript (mdjs) format](https://rocket.modern-web.dev/docs/markdown-javascript/overview/).

## Installation

Run this command to add the gem to your project's Gemfile.

```
bundle add kramdown-parser-gfm-extractions
```

## Usage

Simply require the gem, pass the relevant input option to Kramdown, and you'll get the appropriate HTML output as well as an array of extractions.

~~~ruby
require "kramdown"
require "kramdown-parser-gfm-extractions"

text = <<~MD
  Hello **folks**.

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

doc = Kramdown::Document.new(text, {input: :GFMExtractions})
html = doc.to_html
extractions = doc.root.options[:extractions]
~~~

In this example, the `js script` block and the `html preview-story` block would both be extracted. In the list of extractions available via `doc.root.options[:extractions]`, you'd obtain hashes with the following keys:

* **lang** - the language code (js, html, etc.)
* **meta** - the meta string (script, preview-story, etc.)
* **code** - the actual code block verbatim

By default, the extracted code is still output to the HTML but contained within a custom tag called `kramdown-extraction` containing an inert `template` tag with the rendered output of the syntax processor. If you wish to customize or turn off this behavior, pass these options along to `Kramdown::Document`:

* **include_extraction_tags** - set to `false` to entirely remove the extraction tags
* **include_code_in_extractions** - set to `false` to strip the rendered code templates out of the extraction tags (but still keep the tags themselves)

## Testing

* Run `bundle exec rake test` to run the test suite

## Contributing

1. Fork it (https://github.com/bridgetownrb/kramdown-parser-gfm-extractions/fork)
2. Clone the fork using `git clone` to your local development machine.
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request
