Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.name = 'sinatra-sequel_extension'
  s.version = '0.9.0'
  s.date = '2009-08-08'

  s.description = "Extends Sinatra with Sequel ORM config, migrations, and helpers"
  s.summary = "Sinatra/Sequel integration, forked from Ryan Tomayko's sinatra-sequel September 2014"

  s.authors = ["Dana Scheider"]
  s.email = "dana.scheider@gmail.com"

  # = MANIFEST =
  s.files = %w[
    LICENSE
    README.md
    Rakefile
    gemfiles/sequel_3.2.gemfile
    gemfiles/sequel_4.0.gemfile
    gemfiles/sequel_4.14.gemfile
    gemfiles/sinatra_0.9.4.gemfile
    gemfiles/sinatra_1.1.gemfile 
    gemfiles/sinatra_1.2.gemfile 
    gemfiles/sinatra_1.3.gemfile 
    gemfiles/sinatra_1.4.gemfile
    lib/sinatra/sequel.rb
    sinatra-sequel_extension.gemspec
    spec/sequel_sinatra_spec.rb
    spec/spec_helper.rb
    Appraisals
  ]
  # = MANIFEST =

  s.test_files = s.files.select {|path| path =~ /^spec\/.*.rb/ }
  s.licenses = 'MIT'

  s.extra_rdoc_files = %w[README.md LICENSE]
  s.add_dependency 'sinatra', '>= 0.9.4'
  s.add_dependency 'sequel',   '>= 3.2'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rake', '~> 10.3'
  s.add_development_dependency 'bundler', '~> 1.6'
  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'coveralls', '~> 0.7'
  s.add_development_dependency 'simplecov', '~> 0.9'
  s.add_development_dependency 'appraisal', '~> 1.0'

  s.has_rdoc = true
  s.homepage = "http://github.com/danascheider/sinatra-sequel_extension"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Sinatra::SequelExtension"]
  s.require_paths = %w[lib]
  s.rubyforge_project = 'wink'
  s.rubygems_version = '1.1.1'
end
