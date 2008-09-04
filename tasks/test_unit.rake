require "rake/testtask"

task :default => :test

task :test => :compile

Rake::TestTask.new do |t|
  t.libs << "test" << "test/bundles"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end
