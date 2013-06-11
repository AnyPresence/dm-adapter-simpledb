require 'rspec'
ROOT = File.expand_path('../..', File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(ROOT,'lib'))
require 'aws'
require 'simpledb_adapter'

class Book
  include DataMapper::Resource
  storage_names[:default] = "books"
  storage_names[:backup]  = "tomes"

  property :author,       String, :key => true
  property :date,         Date
  property :text,         DataMapper::Property::Text
  property :tags,         DataMapper::Property::SdbArray
  property :isbn,         String
end

class Product
  include DataMapper::Resource

  property :id,    DataMapper::Property::Serial
  property :name,  String
  property :stock, Integer
end

class Poem
  include ::DataMapper::Resource

  property :text, String, :key => true
end

RSpec.configure do |config|
  config.before :each do
    @sdb = stub("AWS::SdbInterface").as_null_object
    @log = stub("Log").as_null_object
    id = ENV['AMAZON_ACCESS_KEY_ID']
    key  = ENV['AMAZON_SECRET_ACCESS_KEY']
    domain = File.read(File.join(ROOT, 'THROW_AWAY_SDB_DOMAIN')).strip

    @adapter = DataMapper.setup(:default, 
      :adapter       => 'simpledb',
      :access_key    => id,
      :secret_key    => key,
      :domain        => domain,
      :logger        => @log,
      :sdb_interface => @sdb
      )
    
    DataMapper.finalize
  end

  config.after :each do
    DataMapper::Repository.adapters.delete(:default)
  end
  
end
