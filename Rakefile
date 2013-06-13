require 'rspec'
require 'rspec/core/rake_task'
require 'pathname'

DM_VERSION    = '~> 1.2'
OPTS = ['--backtrace', '--colour', '--format', 'progress', '--fail-fast']
ROOT = Pathname(__FILE__).dirname.expand_path

task :default => [ 'spec:unit' ]

namespace :spec do
  desc 'Run unit-level specifications'
  RSpec::Core::RakeTask.new(:unit) do |spec|
    spec.rspec_opts = OPTS
    spec.pattern = 'spec/unit/**/*_spec.rb'
    spec.rcov = false    
  end

  desc 'Run integration-level specifications'
  RSpec::Core::RakeTask.new(:integration) do |spec|
    spec.rspec_opts = OPTS
    spec.pattern = 'spec/integration/*_spec.rb'
    spec.rcov = false
  end

end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name            = "dm-adapter-simpledb"
    gem.summary         = "DataMapper adapter for Amazon SimpleDB"
    gem.email           = "devs@devver.net"
    gem.homepage        = "http://github.com/devver/dm-adapter-simpledb"
    gem.description     = <<END
A DataMapper adapter for Amazon's SimpleDB service. 

Features:
 * Full set of CRUD operations
 * Supports all DataMapper query predicates.
 * Can translate many queries into efficient native SELECT operations.
 * Migrations
 * DataMapper identity map support for record caching
 * Lazy-loaded attributes
 * DataMapper Serial property support via UUIDs.
 * Array properties
 * Basic aggregation support (Model.count("..."))
 * String "chunking" permits attributes to exceed the 1024-byte limit

Note: as of version 1.0.0, this gem supports supports the DataMapper 0.10.*
series and breaks backwards compatibility with DataMapper 0.9.*.
END
    gem.authors         = [
      "Jeremy Boles",
      "Edward Ocampo-Gooding",
      "Dan Mayer",
      "Thomas Olausson",
      "Avdi Grimm"
    ]
    gem.add_dependency('dm-core',               DM_VERSION)
    gem.add_dependency('dm-aggregates',         DM_VERSION)
    gem.add_dependency('dm-migrations',         DM_VERSION)
    gem.add_dependency('dm-types',              DM_VERSION)
    gem.add_dependency('uuidtools',             '~> 2.0')
    gem.add_dependency('sdbtools',              '~> 0.5')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of it's dependencies, is not available."
end
