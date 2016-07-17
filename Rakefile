require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs = []
  t.pattern = 'test/**/test_*.rb'
end

task default: :test
