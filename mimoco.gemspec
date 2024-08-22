lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mimoco/version"

Gem::Specification.new do |s|
  s.name = "mimoco"
  s.version = Mimoco::VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = "Mimoco: some minitests for models and controllers"
  s.description = "Some testing for models and controllers"
  s.authors = ["Dittmar Krall"]
  s.email = ["dittmar.krall@matiq.com"]
  s.homepage = "https://github.com/matique/mimoco"
  s.license = "MIT"

  s.metadata["source_code_uri"] = "https://github.com/matique/mimoco"

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency "combustion"
  s.add_development_dependency "minitest"
end
