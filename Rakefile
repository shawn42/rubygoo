# -*- ruby -*-

require 'rubygems'
require 'hoe'

module Rubygoo
  VERSION = '0.0.7'
end
Hoe.new('rubygoo', Rubygoo::VERSION) do |p|
  p.developer('Shawn Anderson', 'shawn42@gmail.com')
  p.author = "Shawn Anderson"
  p.description = "GUI library for use with Gosu or Rubygame"
  p.email = 'shawn42@gmail.com'
  p.summary = "Easy to use gui library for Rubygame or Gosu."
  p.url = "http://rubygoo.googlecode.com"
  p.changes = p.paragraphs_of('History.txt', 8..9).join("\n\n")
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
  require 'spec/rake/spectask'

  desc "Run all specs (tests)"
  Spec::Rake::SpecTask.new do |t|
    t.spec_files = FileList['test/*_spec.rb']
    t.spec_opts = ["--format", "specdoc"]
  end

  rule(/spec:.+/) do |t|
    name = t.name.gsub("spec:","")

    path = File.join( File.dirname(__FILE__),'test','%s_spec.rb'%name )

    if File.exist? path
      Spec::Rake::SpecTask.new(name) do |t|
      t.spec_files = [path]
    end

    puts "\nRunning spec/%s_spec.rb"%[name]
      Rake::Task[name].invoke
    else
      puts "File does not exist: %s"%path
    end
  end

rescue LoadError
  task :spec do 
    puts "ERROR: RSpec is not installed?"
  end
end


# vim: syntax=Ruby
