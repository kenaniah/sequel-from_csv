# coding: utf-8
# lib = File.expand_path('../lib', __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name          = "sequel-from_csv"
  s.version       = "0.1.1"
  s.authors       = ["Kenaniah Cerny"]
  s.email         = ["kenaniah@gmail.com"]

  s.summary       = "A simple way to seed and synchronize table data using CSV files"
  s.homepage      = "https://github.com/kenaniah/sequel-from_csv"

  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|bin)/})
  end
  s.require_paths = ["lib"]

  s.add_dependency "activesupport" # For String#classify and String#constantize
  s.add_dependency "sequel"

  s.add_development_dependency "bundler", "~> 1.13"
  s.add_development_dependency "rake", "~> 10.0"
end
