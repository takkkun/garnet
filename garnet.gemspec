# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'garnet/version'

Gem::Specification.new do |spec|
  spec.name          = 'garnet'
  spec.version       = Garnet::VERSION
  spec.authors       = ['Takahiro Kondo']
  spec.email         = ['heartery@gmail.com']
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{New Ruby binding of MeCab}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake'
end
