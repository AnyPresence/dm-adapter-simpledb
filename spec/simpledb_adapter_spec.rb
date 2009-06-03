require 'pathname'
require Pathname(__FILE__).dirname.expand_path + 'spec_helper'
require 'ruby-debug'

describe DataMapper::Adapters::SimpleDBAdapter do
  before(:each) do
    @person_attrs = { :id => "person-#{Time.now.to_f.to_s}", :name => 'Jeremy Boles', :age  => 25, 
      :wealth => 25.00, :birthday => Date.today }
    @person = Person.new(@person_attrs)
  end
  
  it 'should create a record' do
    @person.save.should be_true
    @person.id.should_not be_nil
    @person.destroy
  end
  
  describe 'with a saved record' do
    before(:each) { @person.save; sleep(0.2) } #sleep or it might not be on SDB at when the test checks it
    after(:each)  { @person.destroy; sleep(0.2) } #same issues for the next test could still be there
    
    it 'should get a record' do
      person = Person.get!(@person.id, @person.name)
      person.should_not be_nil
      person.wealth.should == @person.wealth
    end
    
    it 'should not get records of the wrong type by id' do
      Company.get(@person.id, @person.name).should == nil
      lambda { Company.get!(@person.id, @person.name) }.should raise_error(DataMapper::ObjectNotFoundError)
    end    

    it 'should update a record' do
      person = Person.get!(@person.id, @person.name)
      person.wealth = 100.00
      person.save
      
      person = Person.get!(@person.id, @person.name)
      person.wealth.should_not == @person.wealth
      person.age.should == @person.age
      person.id.should == @person.id
      person.name.should == @person.name
    end
    
    it 'should destroy a record' do
      @person.destroy.should be_true
    end
  end

  describe 'with nils records saved and retreived' do
    before(:each) do
      @jeremy   = Person.create(@person_attrs.merge(:id => Time.now.to_f.to_s, :name => "Jeremy Boles", :age => 25))
      @danielle = Person.create(@person_attrs.merge(:id => Time.now.to_f.to_s, :name => nil, :age => 26, :birthday => nil))
      sleep(0.3) #or the get calls might not have these created yet
    end
    
    after(:each) do
      @jeremy.destroy
      @danielle.destroy
      sleep(0.2) #or might not be destroyed by the next test
    end
    
    it 'should get all records' do
      Person.all.length.should == 2
    end
    
    it 'should get retrieve nil values' do
      people = Person.all(:age => 26)
      people.length.should == 1
      people[0].name.should == nil
      people[0].birthday.should == nil
    end

  end
  
  describe 'with multiple records saved' do
    before(:each) do
      @jeremy   = Person.create(@person_attrs.merge(:id => Time.now.to_f.to_s, :name => "Jeremy Boles", :age => 25))
      @danielle = Person.create(@person_attrs.merge(:id => Time.now.to_f.to_s, :name => "Danille Boles", :age => 26))
      @keegan   = Person.create(@person_attrs.merge(:id => Time.now.to_f.to_s, :name => "Keegan Jones", :age => 20))
      sleep(0.4) #or the get calls might not have these created yet
    end
    
    after(:each) do
      @jeremy.destroy
      @danielle.destroy
      @keegan.destroy
      sleep(0.4) #or might not be destroyed by the next test
    end
    
    it 'should get all records' do
      Person.all.length.should == 3
    end
    
    it 'should get records by eql matcher' do
      people = Person.all(:age => 25)
      people.length.should == 1
    end

    it 'should get record by eql matcher' do
      person = Person.first(:conditions => {:age => 25})
      person.should_not be_nil
    end
    
    it 'should get records by not matcher' do
      people = Person.all(:age.not => 25)
      people.length.should == 2
    end

    it 'should get record by not matcher' do
      person = Person.first(:age.not => 25)
      person.should_not be_nil
    end
    
    it 'should get records by gt matcher' do
      people = Person.all(:age.gt => 25)
      people.length.should == 1
    end
    
    it 'should get records by gte matcher' do
      people = Person.all(:age.gte => 25)
      people.length.should == 2
    end
    
    it 'should get records by lt matcher' do
      people = Person.all(:age.lt => 25)
      people.length.should == 1
    end
    
    it 'should get records by lte matcher' do
      people = Person.all(:age.lte => 25)
      people.length.should == 2
    end

    it 'should get record by lte matcher' do
      person = Person.first(:age.lte => 25)
      person.should_not be_nil
    end
    
    it 'should get records with multiple matchers' do
      people = Person.all(:birthday => Date.today, :age.lte => 25)
      people.length.should == 2
    end
    
    it 'should handle DateTime' do
      pending 'Need to figure out how to coerce DateTime'
      time = Time.now
      @jeremy.created_at = time
      @jeremy.save
      sleep(0.2)
      person = Person.get!(@jeremy.id, @jeremy.name)
      person.created_at.should == time
    end
    
    it 'should handle Date' do
      person = Person.get!(@jeremy.id, @jeremy.name)
      person.birthday.should == @jeremy.birthday
    end

    it 'should handle limit one case' do
      persons = Person.all(:limit => 1)
      persons.length.should ==1
    end

    #it would be really slow to create over 100 entires to test this until we have batch creation
    it 'should handle limits over the default SDB 100 results limit'

    #it would be really slow to create over 100 entires to test this until we have batch creation
    it 'should get all results over the default SDB 100 results limit'

    it 'should handle ordering asc results' do
      persons = Person.all(:order => [:age.asc])
      persons.inspect #can't access via array until loaded? Weird
      persons[0].should == @keegan
      persons[1].should == @jeremy
      persons[2].should == @danielle
    end
    
    it 'should handle ordering desc results' do
      persons = Person.all(:order => [:age.desc])
      persons.inspect #can't access via array until loaded? Weird
      persons[0].should == @danielle
      persons[1].should == @jeremy
      persons[2].should == @keegan
    end

    it 'should order records'
    it 'should get records by the like matcher'   
  end

  describe 'support migrations' do
    
    before do
      @adapter = repository(:default).adapter
    end
    
    it "should destroy model storage" do
      ENV['destroy']='true'
      @adapter.destroy_model_storage(repository(:default), Person)
      @adapter.storage_exists?("missionaries").should == false
      ENV['destroy']='false'
      @adapter.create_model_storage(repository(:default), Person)
      @adapter.storage_exists?("missionaries").should == true
    end
    
    it "should create model storage" do
      Person.auto_migrate!
      @adapter.storage_exists?("missionaries").should == true
    end
    
  end
  
  describe 'associations' do
    it 'should work with belongs_to associations'
    it 'should work with has n associations'
  end
  
  describe 'STI' do
    it 'should override default type'
    it 'should load descendents on parent.all' 
    it 'should raise an error if you have a column named couchdb_type'
  end

end
