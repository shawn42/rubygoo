# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/rubygoo.rb'

Hoe.new('rubygoo', Rubygoo::VERSION) do |p|
  p.developer('Shawn Anderson', 'shawn42@gmail.com')
  p.author = "Shawn Anderson"
  p.description = "GUI library for use with Gosu or Rubygame"
  p.email = 'boss@topfunky.com'
  p.summary = "Beautiful graphs for one or multiple datasets."
  p.url = "http://rubygoo.googlecode.com"
#  p.changes = p.paragraphs_of('CHANGELOG', 0..1).join("\n\n")
  p.remote_rdoc_dir = '' # Release to root
  p.extra_deps = ['constructor','publisher']
end

# run test_app
task :run do
  sh "rsdl samples/test_app.rb"
end

STATS_DIRECTORIES = [
  %w(Source         lib/)
].collect { |name, dir| [ name, "#{dir}" ] }.select { |name, dir| File.directory?(dir) }

desc "Report code statistics (KLOCs, etc) from the application"
task :stats do
  require 'code_statistics'
  CodeStatistics.new(*STATS_DIRECTORIES).to_s
end

# vim: syntax=Ruby
