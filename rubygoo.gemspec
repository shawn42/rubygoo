require 'rubygems'
Gem::manage_gems
require 'rake/gempackagetask'
spec = Gem::Specification.new do |s|
  s.name = "rubygoo"
  s.version = "0.0.1"
  s.author = "Shawn Anderson"
  s.email = "shawn42@gmail.com"
  s.homepage = "http://rubygoo.googlecode.com"
  s.platform = Gem::Platform::RUBY
  s.summary = "GUI library for the Rubygame"
  s.files = FileList["lib/*.rb","themes/**/*"].to_a
  s.require_path = ["lib"]
  s.autorequire = "rubygoo.rb"
  s.has_rdoc = true
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end
