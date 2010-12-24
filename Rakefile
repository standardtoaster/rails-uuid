require "bundler"
Bundler.setup

gemspec = eval(File.read("rails-uuid.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["rails-uuid.gemspec"] do
  system "gem build rails-uuid.gemspec"
  system "gem install rails-uuid-#{RailsUUID::VERSION}.gem"
end