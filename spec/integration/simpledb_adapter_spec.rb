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
    before(:each) { @friend.save!; sleep(0.4) } #sleep or it might not be on SDB at when the test checks it
    after(:each)  {  sleep(0.4) } #same issues for the next test could still be there
    
    it 'should get a record' do
      person = Friend.get!(@friend.ssn, @friend.name)
      person.should_not be_nil
      person.wealth.should == @friend.wealth
    end
    
    it 'should not get records of the wrong type by ssn' do
      Network.get(@friend.ssn, @friend.name).should == nil
      lambda { Network.get!(@friend.ssn, @friend.name) }.should raise_error(DataMapper::ObjectNotFoundError)
    end    

    it 'should update a record' do
      person = Friend.get!(@friend.ssn, @friend.name)
      person.wealth = 100.00
      person.save
      sleep(0.3)
      person = Friend.get!(@friend.ssn, @friend.name)
      person.wealth.should_not == @friend.wealth
      person.age.should == @friend.age
      person.ssn.should == @friend.ssn
      person.name.should == @friend.name
    end

    it 'should update a record with a long string over 1024' do
      person = Friend.get!(@friend.ssn, @friend.name)
      long_string = "*" * 1026
      person.long_name = long_string
      person.save
      sleep(0.3)
      person = Friend.get!(@friend.ssn, @friend.name)
      person.long_name.should == long_string
      person.ssn.should == @friend.ssn
      person.name.should == @friend.name
    end

    it 'should update a record with with two long strings over 1024' do
      person = Friend.get!(@friend.ssn, @friend.name)
      long_string = "*" * 1026
      long_string_two = (0...2222).map{ ('a'..'z').to_a[rand(26)] }.join
      person.long_name = long_string
      person.long_name_two = long_string_two
      person.save
      sleep(0.3)
      person = Friend.get!(@friend.ssn, @friend.name)
      person.long_name.should == long_string
      person.long_name_two.should == long_string_two
      person.ssn.should == @friend.ssn
      person.name.should == @friend.name
    end

    it 'should save a record with string in the correct order' do
      person = Friend.get!(@friend.ssn, @friend.name)
      person.long_string.should == LONG_VALUE#.gsub("\n","br")
    end

    it 'should destroy a record' do
      @friend.destroy.should be_true
      sleep(0.4) #make sure SDB propigates change
      lambda {Friend.get!(@friend.ssn, @friend.name)}.should raise_error(DataMapper::ObjectNotFoundError)
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

  context "given a pre-existing v0 record" do
    before :each do
      @record_name = "33d9e5a6fcbd746dc40904a6766d4166e14305fe"
      record_attributes = {
        "simpledb_type"  => ["projects"], 
        "project_repo"   => ["git://github.com/TwP/servolux.git"], 
        "files_complete" => ["nil"], 
        "repo_user"      => ["nil"], 
        "ssn"             => ["1077338529"], 
        "description"    => [
            "0002:line 2[[[NEWLINE]]]line 3[[[NEW",
            "0001:line 1[[[NEWLINE]]]",
            "0003:LINE]]]line 4"
          ]
      }
      @sdb.put_attributes(@domain, @record_name, record_attributes)
      sleep 0.4
      @record = Project.get(1077338529)
    end

    it "should interpret legacy nil values correctly" do
      @record.repo_user.should be_nil
    end

    it "should interpret legacy strings correctly" do
      @record.description.should ==
        "line 1\nline 2\nline 3\nline 4"
    end

    it "should save legacy records without adding new metadata" do
      @record.repo_user = "steve"
      @record.save
      sleep 0.4
      attributes = @sdb.get_attributes(@domain, @record_name)[:attributes]
      attributes.should_not include("__dm_metadata")
    end
  end

  describe "given a brand-new record" do
    before :each do
      @record = Project.new(
        :repo_user    => "steve", 
        :ssn           => 123, 
        :project_repo => "git://example.org/foo")
    end

    it "should add metadata to the record on save" do
      @record.save
      sleep 0.4
      items = @sdb.select("select * from #{@domain} where ssn = '123'")[:items]
      attributes = items.first.values.first
      attributes["__dm_metadata"].should include("v01.01.00")
      attributes["__dm_metadata"].should include("table:projects")
    end
  end

end
