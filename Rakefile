#require files

task :default => :run
# run test_app
task :run do
  sh "rsdl test_app.rb"
end

#Install rubygoo
task :build do
	sh "gem build rubygoo.gemspec"
	sh "sudo gem install rubygoo --local"
end
