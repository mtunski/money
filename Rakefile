require 'rake/testtask'

desc "Run tests"
Rake::TestTask.new do |task|
  task.libs << 'test'
  task.test_files = FileList['test/test*.rb']
end
