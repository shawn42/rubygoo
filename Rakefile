#require files

task :default => :run
# run test_app
task :run do
  sh "rsdl test_app.rb"
end

# build the gem
task :build do
	sh "gem build rubygoo.gemspec"
end

# install rubygoo gem
task :install do
	sh "sudo gem install rubygoo --local"
end

# uninstall rubygoo gem
task :uninstall do
	sh "sudo gem uninstall rubygoo"
end

STATS_DIRECTORIES = [
  %w(Source         lib/)
].collect { |name, dir| [ name, "#{dir}" ] }.select { |name, dir| File.directory?(dir) }

desc "Report code statistics (KLOCs, etc) from the application"
task :stats do
  require 'code_statistics'
  CodeStatistics.new(*STATS_DIRECTORIES).to_s
end
