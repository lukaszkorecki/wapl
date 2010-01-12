# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wapl}
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lukasz Korecki"]
  s.date = %q{2010-01-12}
  s.description = %q{Library and helper for communicating with Wapple.net Architect web service, more information: http://wapl.info}
  s.email = %q{lukasz@coffeesounds.com}
  s.extra_rdoc_files = ["README.md", "lib/wapl.rb", "lib/wapl_helper.rb", "tasks/wapl_tasks.rake"]
  s.files = ["MIT-LICENSE", "README.md", "Rakefile", "init.rb", "install.rb", "lib/wapl.rb", "lib/wapl_helper.rb", "tasks/wapl_tasks.rake", "test/test_helper.rb", "test/test_wapl.rb", "test/test_wapl_helper.rb", "uninstall.rb", "Manifest", "wapl.gemspec"]
  s.homepage = %q{http://github.com/plugawy/wapl}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Wapl", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{wapl}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Library and helper for communicating with Wapple.net Architect web service, more information: http://wapl.info}
  s.test_files = ["test/test_wapl.rb", "test/test_helper.rb", "test/test_wapl_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
