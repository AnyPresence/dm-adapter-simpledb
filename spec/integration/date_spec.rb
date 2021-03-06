require 'pathname'
require Pathname(__FILE__).dirname.expand_path + 'spec_helper'

describe 'with multiple records saved' do
  before(:each) do
    Professor.destroy
    @person_attrs = { :id => "person-#{Time.now.to_f.to_s}", :name => 'Jeremy Boles', :age  => 25, :wealth => 25.00, :birthday => Date.today }
    @jeremy   = Professor.create(@person_attrs.merge(:id => Time.now.to_f.to_s, :name => "Jeremy Boles", :age => 25))
    @danielle = Professor.create(@person_attrs.merge(:id => Time.now.to_f.to_s, :name => "Danille Boles", :age => 26))
    @keegan   = Professor.create(@person_attrs.merge(:id => Time.now.to_f.to_s, :name => "Keegan Jones", :age => 20))
  end
  
  after(:each) do
    @jeremy.destroy
    @danielle.destroy
    @keegan.destroy
  end
  
  it 'should handle DateTime' do
    time = DateTime.civil(1970,1,1)
    @jeremy.created_at = time
    @jeremy.save
    person = Professor.get!(@jeremy.id, @jeremy.name)
    person.created_at.should == time
  end
  
  it 'should handle Date' do
    person = Professor.get!(@jeremy.id, @jeremy.name)
    person.birthday.should == @jeremy.birthday
  end
  
  it 'should match with Data' do
    people = Professor.all(:birthday => Date.today)
    people.length.should == 3
  end

end
