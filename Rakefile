require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'echoe'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the wapl plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/test_*.rb'
  t.verbose = true
end

desc 'Generate documentation for the wapl plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Wapl'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Echoe.new('wapl', '0.1') do |p|
  p.description = "Library and helper for communicating with Wapple.net Architect web service, more information: http://wapl.info"
  p.url = "http://github.com/plugawy/wapl"
  p.author = "Lukasz Korecki"
  p.email = "lukasz@coffeesounds.com"
  p.development_dependencies= []
end
