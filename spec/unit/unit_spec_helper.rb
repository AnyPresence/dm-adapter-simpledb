require 'rspec'
ROOT = File.expand_path('../..', File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(ROOT,'lib'))
require 'aws'
require 'simpledb_adapter'

RSpec.configure do |config|
  config.before :each do
    @sdb = stub("AWS::SdbInterface").as_null_object
    @log = stub("Log").as_null_object
    id = ENV['AMAZON_ACCESS_KEY_ID']
    key  = ENV['AMAZON_SECRET_ACCESS_KEY']
    domain = File.read(File.join(ROOT, 'THROW_AWAY_SDB_DOMAIN')).strip

    DataMapper.setup(:default, 
      :adapter       => 'simpledb',
      :access_key    => id,
      :secret_key    => key,
      :domain        => domain,
      :logger        => @log,
      :sdb_interface => @sdb
      )
  end

  config.after :each do
    DataMapper::Repository.adapters.delete(:default)
  end
  
end
