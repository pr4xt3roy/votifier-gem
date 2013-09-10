require 'rake/testtask'
require 'rspec/core/rake_task'

Rake::TestTask.new do |t|
  t.libs << 'test'
end
RSpec::Core::RakeTask.new('spec')

desc "Run tests"
task :default => [] do
  Rake::Task[:test].execute
  Rake::Task[:spec].execute
end
