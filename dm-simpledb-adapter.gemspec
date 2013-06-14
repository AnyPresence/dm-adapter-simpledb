# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name = "dm-simpledb-adapter"
  s.version = "1.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Boles", "Edward Ocampo-Gooding", "Dan Mayer", "Thomas Olausson", "Avdi Grimm"]
  s.date = "2013-06-14"
  s.description = "A DataMapper adapter for Amazon's SimpleDB service. \n\nFeatures:\n * Full set of CRUD operations\n * Supports all DataMapper query predicates.\n * Can translate many queries into efficient native SELECT operations.\n * Migrations\n * DataMapper identity map support for record caching\n * Lazy-loaded attributes\n * DataMapper Serial property support via UUIDs.\n * Array properties\n * Basic aggregation support (Model.count(\"...\"))\n * String \"chunking\" permits attributes to exceed the 1024-byte limit\n\nNote: as of version 1.0.0, this gem supports supports the DataMapper 0.10.*\nseries and breaks backwards compatibility with DataMapper 0.9.*.\n"
  s.email = "devs@devver.net"
  s.extra_rdoc_files = [
    "LICENSE",
    "README"
  ]
  s.files = [
    ".autotest",
    "Gemfile",
    "Gemfile.lock",
    "History.txt",
    "LICENSE",
    "README",
    "Rakefile",
    "VERSION",
    "aws_config.sample",
    "dm-simpledb-adapter.gemspec",
    "lib/dm-simpledb-adapter.rb",
    "lib/simpledb_adapter.rb",
    "scripts/console",
    "scripts/limits_benchmark",
    "scripts/simple_benchmark.rb",
    "scripts/union_benchmark",
    "spec/integration/associations_spec.rb",
    "spec/integration/compliance_spec.rb",
    "spec/integration/date_spec.rb",
    "spec/integration/limit_and_order_spec.rb",
    "spec/integration/migrations_spec.rb",
    "spec/integration/multiple_records_spec.rb",
    "spec/integration/nils_spec.rb",
    "spec/integration/sdb_array_spec.rb",
    "spec/integration/simpledb_adapter_spec.rb",
    "spec/integration/spec_helper.rb",
    "spec/unit/dm_adapter_simpledb/where_expression_spec.rb",
    "spec/unit/record_spec.rb",
    "spec/unit/simpledb_adapter_spec.rb",
    "spec/unit/unit_spec_helper.rb"
  ]
  s.homepage = "http://github.com/devver/dm-simpledb-adapter"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "DataMapper adapter for Amazon SimpleDB"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bundler>, ["~> 1.3.5"])
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<dm-migrations>, ["~> 1.2"])
      s.add_runtime_dependency(%q<dm-types>, ["~> 1.2"])
      s.add_runtime_dependency(%q<dm-aggregates>, ["~> 1.2"])
      s.add_runtime_dependency(%q<dm-core>, ["~> 1.2"])
      s.add_runtime_dependency(%q<dm-validations>, ["~> 1.2"])
      s.add_runtime_dependency(%q<aws>, ["~> 2.1"])
      s.add_runtime_dependency(%q<sdbtools>, ["~> 0.5.0"])
      s.add_runtime_dependency(%q<uuidtools>, ["~> 2.0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_runtime_dependency(%q<dm-core>, ["~> 1.2"])
      s.add_runtime_dependency(%q<dm-aggregates>, ["~> 1.2"])
      s.add_runtime_dependency(%q<dm-migrations>, ["~> 1.2"])
      s.add_runtime_dependency(%q<dm-types>, ["~> 1.2"])
      s.add_runtime_dependency(%q<uuidtools>, ["~> 2.0"])
      s.add_runtime_dependency(%q<sdbtools>, ["~> 0.5"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3.5"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<dm-migrations>, ["~> 1.2"])
      s.add_dependency(%q<dm-types>, ["~> 1.2"])
      s.add_dependency(%q<dm-aggregates>, ["~> 1.2"])
      s.add_dependency(%q<dm-core>, ["~> 1.2"])
      s.add_dependency(%q<dm-validations>, ["~> 1.2"])
      s.add_dependency(%q<aws>, ["~> 2.1"])
      s.add_dependency(%q<sdbtools>, ["~> 0.5.0"])
      s.add_dependency(%q<uuidtools>, ["~> 2.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<dm-core>, ["~> 1.2"])
      s.add_dependency(%q<dm-aggregates>, ["~> 1.2"])
      s.add_dependency(%q<dm-migrations>, ["~> 1.2"])
      s.add_dependency(%q<dm-types>, ["~> 1.2"])
      s.add_dependency(%q<uuidtools>, ["~> 2.0"])
      s.add_dependency(%q<sdbtools>, ["~> 0.5"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3.5"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<dm-migrations>, ["~> 1.2"])
    s.add_dependency(%q<dm-types>, ["~> 1.2"])
    s.add_dependency(%q<dm-aggregates>, ["~> 1.2"])
    s.add_dependency(%q<dm-core>, ["~> 1.2"])
    s.add_dependency(%q<dm-validations>, ["~> 1.2"])
    s.add_dependency(%q<aws>, ["~> 2.1"])
    s.add_dependency(%q<sdbtools>, ["~> 0.5.0"])
    s.add_dependency(%q<uuidtools>, ["~> 2.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<dm-core>, ["~> 1.2"])
    s.add_dependency(%q<dm-aggregates>, ["~> 1.2"])
    s.add_dependency(%q<dm-migrations>, ["~> 1.2"])
    s.add_dependency(%q<dm-types>, ["~> 1.2"])
    s.add_dependency(%q<uuidtools>, ["~> 2.0"])
    s.add_dependency(%q<sdbtools>, ["~> 0.5"])
  end
end

