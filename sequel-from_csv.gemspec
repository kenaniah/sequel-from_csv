# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name          = "sequel-from_csv"
  s.version       = "0.2.0"
  s.authors       = ["Kenaniah Cerny"]
  s.email         = ["kenaniah@gmail.com"]

  s.summary       = "A simple way to seed and synchronize table data using CSV files"
  s.homepage      = "https://github.com/kenaniah/sequel-from_csv"

  s.files         = `git ls-files -z`.split("\x0").select{ |f| f.match(/lib\//) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 2.3.0'

  s.add_dependency "activesupport" # For String#classify and String#constantize
  s.add_dependency "sequel"

  s.add_development_dependency "pg"
  s.add_development_dependency "appraisal"
  s.add_development_dependency "minitest"
  s.add_development_dependency "minitest-reporters"
  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "pry"
end
