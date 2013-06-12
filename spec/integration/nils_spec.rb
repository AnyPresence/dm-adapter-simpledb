require 'pathname'
require Pathname(__FILE__).dirname.expand_path + 'spec_helper'

describe 'with nils records saved and retreived' do
  before(:all) do
    @person_attrs = { :id => "person-#{Time.now.to_f.to_s}", :name => 'Jeremy Boles', :age  => 25, :wealth => 25.00, :birthday => Date.today }
    @jeremy   = Enemy.create(@person_attrs.merge(:id => Time.now.to_f.to_s, :name => "Jeremy Boles", :age => 25))
    @danielle = Enemy.create(@person_attrs.merge(:id => Time.now.to_f.to_s, :name => "Danielle", :age => nil, :birthday => nil))
  end
  
  after(:all) do
    Enemy.destroy
  end
  
  it 'should get all records' do
    Enemy.all.length.should == 2
  end
  
  it 'should retrieve nil values' do
    records = people = Enemy.all(:name => "Danielle")
    people.length.should == 1
    people[0].age.should == nil
    people[0].birthday.should == nil
  end

  it 'should find based on nil values' do
    @people = Enemy.all(:age => nil)
    @people.should include(@danielle)
  end

end
