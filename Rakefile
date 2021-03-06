# -*- ruby -*-

require 'rubygems'
require 'hoe'

module Rubygoo
  VERSION = '0.1.0'
end
Hoe.new('rubygoo', Rubygoo::VERSION) do |p|
  p.developer('Shawn Anderson', 'shawn42@gmail.com')
  p.author = "Shawn Anderson"
  p.description = "GUI library for use with Gosu or Rubygame"
  p.email = 'shawn42@gmail.com'
  p.summary = "Easy to use gui library for Rubygame or Gosu."
  p.url = "http://rubygoo.googlecode.com"
  p.changes = p.paragraphs_of('History.txt', 12..13).join("\n\n")
  p.remote_rdoc_dir = '' # Release to root
  p.extra_deps << ['constructor']
  p.extra_deps << ['publisher']
  p.extra_deps << ['rspec']
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

begin
  require 'rake'
  require 'spec/rake/spectask'

  desc "Run all specs"
  Spec::Rake::SpecTask.new('specs') do |t|
      t.spec_files = FileList['test/*_spec.rb']
  end

rescue LoadError
  task :spec do 
    puts "ERROR: RSpec is not installed?"
  end
end


# vim: syntax=Ruby
