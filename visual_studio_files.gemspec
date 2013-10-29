# coding: utf-8
lib = File.expand_path('./lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

# building: gem build .\visual_studio_files.gemspec
# gem install .\visual_studio_files.gem

Gem::Specification.new do |spec|
  spec.name        = 'visual_studio_files'
  spec.version     = '0.1.1'
  spec.licenses    = []
  spec.authors     = ["wallymathieu"]
  spec.email       = ["support@lundalogik.se"]
  spec.homepage    = "https://github.com/Lundalogik/visual_studio_files"
  spec.summary     = %q{A simple library to manipulate visual studio files}
  spec.description = %q{This library is intended to help when manipulating such things as the files included in a visual studio project. Or verify some condition related to the files in the project.}

  spec.required_ruby_version = '>= 1.9.2' 

  spec.files         = Dir.glob('lib/**/*.rb')
  spec.require_paths = ["lib"]
end