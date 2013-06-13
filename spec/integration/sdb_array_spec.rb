require 'pathname'
require Pathname(__FILE__).dirname.expand_path + 'spec_helper'
require 'dm-adapter-simpledb/sdb_array'

describe 'with multiple records saved' do
  
  class Hobbyist
    include DataMapper::Resource
    property :name,       String, :key => true
    property :hobbies,    SdbArray
  end
  
  before(:each) do
    @jeremy   = Hobbyist.create(:name => "Jeremy Boles",  :hobbies => ["biking", "diving", "chess"])
    @danielle = Hobbyist.create(:name => "Danille Boles", :hobbies => ["swimming", "diving"])
    @keegan   = Hobbyist.create(:name => "Keegan Jones",  :hobbies => ["painting"])
  end
  
  after(:each) do
    @jeremy.destroy
    @danielle.destroy
    @keegan.destroy
  end
  
  it 'should store hobbies as array' do
    person = Hobbyist.first(:name => 'Jeremy Boles')
    garbage = person.hobbies.sort
    garbage.should == ["biking", "diving", "chess"].sort
  end
  
  it 'should allow updates to array' do
    person = Hobbyist.first(:name => 'Jeremy Boles')
    person.hobbies = ["lego"]
    person.save
    lego_person = Hobbyist.first(:name => 'Jeremy Boles')
    lego_person.hobbies.should == ["lego"]
  end
  
  it 'should allow deletion of array' do
    person = Hobbyist.first(:name => 'Jeremy Boles')
    person.hobbies = []
    person.save
    lego_person = Hobbyist.first(:name => 'Jeremy Boles')
    lego_person.hobbies.should == []
  end
  
  it 'should find all records with diving hobby' do
    people = Hobbyist.all(:hobbies => ["snorkling"])
    people.should be_empty
  end
  
  it 'should find all records with painting hobby' do
    people = Hobbyist.all(:hobbies => ["painting"])
    people.should_not include(@jeremy)
    people.should_not include(@danielle)
    people.should     include(@keegan)
  end
=begin TODO
  it "should find all records with like operator" do
    people = Hobbyist.all(:hobbies.like => 'pa%')
    people.should_not include(@jeremy)
    people.should_not include(@danielle)
    people.should     include(@keegan)
  end
=end
end
