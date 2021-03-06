require File.expand_path("../lib/rails-uuid/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "rails-uuid"
  s.version     = RailsUUID::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andrew Preece"]
  s.email       = ["andrew.preece@gmail.com"]
  s.homepage    = "http://www.lako.ca"
  s.summary     = "Makes rails use UUID's for ID columns"
  s.description = "You're definitely going to want to replace a lot of this"

  s.required_rubygems_version = ">= 1.3.6"

  # lol - required for validation
  s.rubyforge_project         = "rails-uuid"

  # If you have other dependencies, add them here
  s.add_dependency "uuidtools"
  
  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'


  # If you have C extensions, uncomment this line
  # s.extensions = "ext/extconf.rb"
end