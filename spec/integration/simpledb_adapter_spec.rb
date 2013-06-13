require 'pathname'
require Pathname(__FILE__).dirname.expand_path + 'spec_helper'

describe DataMapper::Adapters::SimpleDBAdapter do

  before(:each) do
    @friend = Friend.new(:ssn => "person-#{Time.now.to_f.to_s}", :name => 'Jeremy Boles', :age  => 25, :wealth => 25.00, :birthday => Date.today,
      :long_name => 'short', :long_name_two => 'short', :long_string => LONG_VALUE)
  end
  
  it 'should create a record' do
    @friend.save!
    Friend.all.each do |friend|
      friend.should == @friend
    end
    @friend.ssn.should_not be_nil
    @friend.destroy
  end
  
  describe 'with a saved record' do
    before(:each) do 
      network = Network.create(:name => "Creeps")
      @friend.network = network
      @friend.save 
      sleep(0.4)
    end
    after(:each)  do
      Friend.destroy
      Network.destroy
      sleep(0.4) 
    end
    
    it 'should get a record' do
      person = Friend.get!(@friend.id, @friend.ssn, @friend.name)
      person.should_not be_nil
      person.wealth.should == @friend.wealth
    end
    
    it 'should not get records of the wrong type by ssn' do
      Network.get(@friend.id).should == nil
      lambda { Network.get!(@friend.ssn) }.should raise_error(DataMapper::ObjectNotFoundError)
    end    

    it 'should update a record' do
      person = Friend.get!(@friend.id,@friend.ssn, @friend.name)
      person.wealth = 100.00
      person.save
      sleep(0.3)
      person = Friend.get!(@friend.id,@friend.ssn, @friend.name)
      person.wealth.should_not == @friend.wealth
      person.age.should == @friend.age
      person.ssn.should == @friend.ssn
      person.name.should == @friend.name
    end

    it 'should update a record with a long string over 1024' do
      person = Friend.get!(@friend.id,@friend.ssn, @friend.name)
      long_string = "*" * 1026
      person.long_name = long_string
      person.save
      sleep(0.3)
      person = Friend.get!(@friend.id,@friend.ssn, @friend.name)
      person.long_name.should == long_string
      person.ssn.should == @friend.ssn
      person.name.should == @friend.name
    end

    it 'should update a record with with two long strings over 1024' do
      person = Friend.get!(@friend.id,@friend.ssn, @friend.name)
      long_string = "*" * 1026
      long_string_two = (0...2222).map{ ('a'..'z').to_a[rand(26)] }.join
      person.long_name = long_string
      person.long_name_two = long_string_two
      person.save
      sleep(0.3)
      person = Friend.get!(@friend.id,@friend.ssn, @friend.name)
      person.long_name.should == long_string
      person.long_name_two.should == long_string_two
      person.ssn.should == @friend.ssn
      person.name.should == @friend.name
    end

    it 'should save a record with string in the correct order' do
      person = Friend.get!(@friend.id,@friend.ssn, @friend.name)
      person.long_string.should == LONG_VALUE#.gsub("\n","br")
    end

    it 'should destroy a record' do
      @friend.destroy.should be_true
      sleep(0.4) #make sure SDB propigates change
      lambda {Friend.get!(@friend.id,@friend.ssn, @friend.name)}.should raise_error(DataMapper::ObjectNotFoundError)
      persons = Friend.all(:name => @friend.name)
      persons.length.should == 0
    end

    describe 'aggregate' do
      it "should respond to count(*)" do
        Friend.count.should == 1
      end
      it "should not respond to any other aggregates" do
        lambda { Friend.min(:age) }.should raise_error(NotImplementedError)
        lambda { Friend.max(:age) }.should raise_error(NotImplementedError)
        lambda { Friend.avg(:age) }.should raise_error(NotImplementedError)
        lambda { Friend.sum(:age) }.should raise_error(NotImplementedError)
      end
    end
  end

end
