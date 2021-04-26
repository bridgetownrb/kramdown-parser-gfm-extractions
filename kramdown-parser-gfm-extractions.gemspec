# frozen_string_literal: true

require_relative "lib/kramdown-parser-gfm-extractions/version"

Gem::Specification.new do |spec|
  spec.name          = "kramdown-parser-gfm-extractions"
  spec.version       = KramdownParserGFMExtractions::VERSION
  spec.author        = "Bridgetown Team"
  spec.email         = "maintainers@bridgetownrb.com"
  spec.summary       = "A subclass of Kramdown's GFM parser which extracts fenced code blocks featuring meta (aka `js script`)"
  spec.homepage      = "https://github.com/bridgetownrb/kramdown-parser-gfm-extractions"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.5"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r!^(test|script|spec|features)/!) }
  spec.require_paths = ["lib"]

  spec.add_dependency("kramdown", "~> 2.0")
  spec.add_dependency("kramdown-parser-gfm", "~> 1.0")
end
