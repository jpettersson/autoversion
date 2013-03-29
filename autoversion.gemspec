# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "autoversion/version"

Gem::Specification.new do |s|
  s.name        = 'autoversion'
  s.version     = Autoversion::VERSION
  s.date        = '2013-03-27'
  s.summary     = "Automate your Semantic Versioning with git and hooks"
  s.description = "Yeah"
  s.authors     = ["Jonathan Pettersson"]
  s.email       = 'jonathan@spacetofu.com'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.homepage    = 'https://github.com/jpettersson/autoversion'
  s.executables << 'autoversion'

  s.add_development_dependency "rspec", "2.13.0"
  s.add_runtime_dependency "thor", "0.17.0"
  s.add_runtime_dependency "git"
  s.add_runtime_dependency "semantic", "1.1.0"
end