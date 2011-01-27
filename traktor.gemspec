$:.push File.expand_path("../lib", __FILE__)
require "traktor/version"

Gem::Specification.new do |s|
  s.name        = "traktor"
  s.version     = Traktor::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Vincent De Snerck"]
  s.email       = ["vincent@moar.be"]
  s.homepage    = ""
  s.summary     = %q{Wrapper for trakt.tv API}
  s.description = %q{Wrapper for trakt.tv API}

  s.add_dependency "json"
  s.add_dependency "rest-client"
  s.add_development_dependency "rspec", "~> 2.3.0"
  s.add_development_dependency "autotest"
  s.add_development_dependency "autotest-growl"
  s.add_development_dependency "webmock"
  s.add_development_dependency "pry"

  s.rubyforge_project = "traktor"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end