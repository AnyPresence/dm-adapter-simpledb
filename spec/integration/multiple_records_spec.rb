require 'pathname'
require Pathname(__FILE__).dirname.expand_path + 'spec_helper'

describe 'with multiple records saved' do
  before(:each) do
    Person.destroy
    @jeremy   = Person.create(:ssn => Time.now.to_f.to_s, :name => "Jeremy Boles", :age => 25, :wealth => 25.00)
    @danielle = Person.create(:ssn => Time.now.to_f.to_s, :name => "Danille Boles", :age => 26, :wealth => 25.00)
    @keegan   = Person.create(:ssn => Time.now.to_f.to_s, :name => "Keegan Jones", :age => 20, :wealth => 25.00)
  end
  
  after(:all) do
    Person.destroy
  end
  
  it 'should get all records' do
    Person.all.each do |person|
      [@jeremy, @danielle, @keegan].should be_include(person)
    end
  end
  
  it 'should get records by eql matcher' do
    Person.all(:age => 25).each_with_index do |person, index|
      person.should == @jeremy
      index.should == 0
    end
  end

  it 'should get record by eql matcher' do
    Person.all(:conditions => {:age => 25}).each_with_index do |person, index|
      person.should == @jeremy
      index.should == 0
    end
  end
  
  it 'should get records by not matcher' do
    Person.all(:age.not => 25).each do |person|
      person.should_not == @jeremy
    end
  end
  
  it 'should get records by gt matcher' do
    people = Person.all(:age.gt => 25).each_with_index do |person, index|
      person.should == @danielle
      index.should == 0
    end
  end
  
  it 'should get records by gte matcher' do
    people = Person.all(:age.gte => 25).each_with_index do |person, index|
      [@jeremy, @danielle].should be_include(person)
      index.should < 2
    end
  end
  
  it 'should get records by lt matcher' do
    people = Person.all(:age.lt => 25).each_with_index do |person, index|
      person.should == @keegan
      index.should == 0
    end
  end
  
  it 'should get records by lte matcher' do
    people = Person.all(:age.lte => 25).each_with_index do |person, index|
      [@jeremy, @keegan].should be_include(person)
      index.should < 2
    end
  end
  
  it 'should get records with multiple matchers' do
    people = Person.all(:wealth => 25.00, :age.lte => 25).each_with_index do |person, index|
      [@jeremy, @keegan].should be_include(person)
      index.should < 2
    end
  end

  it 'should get records by the like matcher' do
    people = Person.all(:name.like => 'Jeremy%').each do |person|
      person.should == @jeremy
    end
  end
  
  it 'should get records by the IN matcher' do
    people = Person.all(:ssn => [@jeremy.ssn, @danielle.ssn]).each_with_index do |person, index|
      [@jeremy, @danielle].should be_include(person)
      @keegan.should_not == person
      index.should < 2
    end
  end
  it "should get no records if IN array is empty" do
    people = Person.all(:ssn => [])
    people.should be_empty
  end
end
