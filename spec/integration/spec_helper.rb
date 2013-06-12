require 'pathname'
ROOT = File.expand_path('../..', File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(ROOT,'lib'))
require 'simpledb_adapter'
require 'logger'
require 'fileutils'
require 'rspec'
require 'rspec/core'
require 'dm-validations'
DOMAIN_FILE_MESSAGE = <<END
!!! ATTENTION !!!
In order to operate, these specs need a throwaway SimpleDB domain to operate
in. This domain WILL BE DELETED BEFORE EVERY SUITE IS RUN. In order to 
avoid unexpected data loss, you are required to manually configure the 
throwaway domain. In order to configure the domain, create a file in the
project root directory named THROW_AWAY_SDB_DOMAIN. It's contents should be 
the name of the SimpleDB domain to use for tests. E.g.

    $ echo dm_simpledb_adapter_test > THROW_AWAY_SDB_DOMAIN

END

class Heffalump
  include DataMapper::Resource
  property :id,        DataMapper::Property::Serial
  property :color,     DataMapper::Property::String
  property :num_spots, DataMapper::Property::Integer
  property :striped,   DataMapper::Property::Boolean

  # This is needed for DataMapper.finalize
  def self.name
    'Heffalump'
  end
end

class Professor
  include DataMapper::Resource
  
  property :id,         String, :key => true
  property :name,       String, :key => true
  property :age,        Integer
  property :wealth,     Float
  property :birthday,   Date
  property :created_at, DateTime
  
end

class Hero
  include DataMapper::Resource
  
  property :id,         String, :key => true
  property :name,       String, :key => true
  property :age,        Integer
  property :wealth,     Float
  property :birthday,   Date
  property :created_at, DateTime
  
end

class Fluffy
  include DataMapper::Resource
  
  property :id,         Serial
  property :name,       String, :key => true
  property :age,        Integer
  property :wealth,     Float
  property :birthday,   Date
  property :created_at, DateTime
  
end

class Person
  include DataMapper::Resource
  property :id,         DataMapper::Property::Serial
  property :ssn,        DataMapper::Property::String
  property :name,       DataMapper::Property::String
  property :age,        DataMapper::Property::Integer
  property :wealth,     DataMapper::Property::Float
  property :birthday,   DataMapper::Property::Date
  property :created_at, DataMapper::Property::DateTime
  
  belongs_to :company
end

#TODO write some tests with company or drop this
class Company
  include DataMapper::Resource
  
  property :id,   DataMapper::Property::Serial
  property :name, DataMapper::Property::String, :key => true
  
  has n, :people
end

class Enemy
  include DataMapper::Resource
  
  property :id,         String, :key => true
  property :name,       String, :key => true
  property :age,        Integer
  property :wealth,     Float
  property :birthday,   Date
  property :created_at, DateTime
end

class Friend
  include DataMapper::Resource

  property :ssn,        DataMapper::Property::String, :key => true
  property :name,       DataMapper::Property::String, :key => true
  property :long_name,  DataMapper::Property::String
  property :long_name_two,  DataMapper::Property::String
  property :age,        DataMapper::Property::Integer
  property :wealth,     DataMapper::Property::Float
  property :birthday,   DataMapper::Property::Date
  property :created_at, DataMapper::Property::DateTime
  property :long_string, DataMapper::Property::String
  
  belongs_to :network
end

class Network
  include DataMapper::Resource
  
  property :id,   DataMapper::Property::String, :key => true
  property :name, DataMapper::Property::String, :key => true
  
  has n, :friends
end

class Project
  include DataMapper::Resource
  property :id, DataMapper::Property::Integer, :key => true
  property :project_repo, DataMapper::Property::String
  property :repo_user, DataMapper::Property::String
  property :description, DataMapper::Property::String
end

LONG_VALUE = <<TEXT
This is some garbage really. I mean I don't know what else to say at this point. 
But yay and go team, or else ManBearPig will get you, thuper therial!

TEXT
RSpec.configure do |config|
  access_key  = ENV['AMAZON_ACCESS_KEY_ID']
  secret_key  = ENV['AMAZON_SECRET_ACCESS_KEY']
  domain_file = File.join(ROOT, 'THROW_AWAY_SDB_DOMAIN')
  test_domain = File.read(File.join(ROOT, 'THROW_AWAY_SDB_DOMAIN')).strip

  # Run just once
  config.before :suite do
    FileUtils.mkdir_p('log') unless File.exists?('log')
    log_file = "log/dm-sdb.log"
    FileUtils.touch(log_file)
    log = Logger.new(log_file)
    log.level = ::Logger::DEBUG
    DataMapper.logger.level = :debug

    DataMapper.logger.set_log(log_file, :debug)
    adapter = DataMapper.setup(:default, {
        :adapter => 'simpledb',
        :access_key => access_key,
        :secret_key => secret_key,
        :domain => test_domain,
        :logger => log,
        :wait_for_consistency => :manual
      })
    $control_sdb = adapter.sdb_interface
    DataMapper.finalize
  end

  # Run before each group
  config.before :all do
    @adapter = DataMapper::Repository.adapters[:default]
    @sdb ||= $control_sdb
    @sdb.delete_domain(test_domain)
    @sdb.create_domain(test_domain)
    @domain = test_domain
  end
end
