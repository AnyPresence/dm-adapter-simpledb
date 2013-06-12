require 'pathname'
require Pathname(__FILE__).dirname.expand_path + 'spec_helper'
require 'dm-migrations'

describe 'support migrations' do
  

#  test can't be run simultanious make it delete a throwawaable storage model
#  instead of the one used by all the tests 
#  it "should destroy model storage" do
#    ENV['destroy']='true'
#    @adapter.destroy_model_storage(repository(:default), Person)
#    @adapter.storage_exists?("missionaries").should == false
#    ENV['destroy']='false'
#    @adapter.create_model_storage(repository(:default), Person)
#    @adapter.storage_exists?("missionaries").should == true
#  end
  
  before :all do
#    @sdb.delete_domain(@domain)
    Fluffy.destroy
  end

  it "should create model storage" do
    person = Fluffy.create(:name => "Humpty Dumpty")
    Fluffy.all.should include(person)
  end
  
end

