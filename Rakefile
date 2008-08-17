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
