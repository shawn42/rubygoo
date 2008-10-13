# -*- ruby -*-

require 'rubygems'
require 'hoe'

module Rubygoo
  VERSION = '0.0.5'
end
Hoe.new('rubygoo', Rubygoo::VERSION) do |p|
  p.developer('Shawn Anderson', 'shawn42@gmail.com')
  p.author = "Shawn Anderson"
  p.description = "GUI library for use with Gosu or Rubygame"
  p.email = 'boss@topfunky.com'
  p.summary = "Beautiful graphs for one or multiple datasets."
  p.url = "http://rubygoo.googlecode.com"
  p.changes = p.paragraphs_of('History.txt', 0..2).join("\n\n")
  p.remote_rdoc_dir = '' # Release to root
  p.extra_deps << ['constructor']
  p.extra_deps << ['publisher']
end

# run rubygame_app
task :run do
  # this is for convenience on os x
  sh "rsdl samples/rubygame_app.rb"
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
