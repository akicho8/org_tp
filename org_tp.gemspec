# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'org_tp/version'

Gem::Specification.new do |spec|
  spec.name         = "org_tp"
  spec.version      = OrgTp::VERSION
  spec.author       = "akicho8"
  spec.email        = "akicho8@gmail.com"
  spec.homepage     = "https://github.com/akicho8/org_tp"
  spec.summary      = "OrgTp shows ascii table like emacs org-table for easy reading."
  spec.description  = "OrgTp shows ascii table like emacs org-table for easy reading."
  spec.platform     = Gem::Platform::RUBY

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.rdoc_options  = ["--line-numbers", "--inline-source", "--charset=UTF-8", "--diagram", "--image-format=jpg"]

  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "sqlite3"
end
