require File.expand_path('unit_spec_helper', File.dirname(__FILE__))
require 'simpledb_adapter'

describe DataMapper::Adapters::SimpleDBAdapter do


  describe "given a record" do
    before :each do
      @record = Product.new(:name => "War and Peace", :stock => 1)
    end
    
    it "should be able to save the record" do
      @record.id.should == nil
      @record.save!
      @record.id.should_not == nil
    end
  end

  describe "given an existing record" do
    before :each do
      @id
      @record = Product.new(:name => "Alice in Wonderland", :stock => 3)
      @record.save!
      @id = @record.id
    end
    
    it "should be able to update the record" do
      @record.stock = 5
      @record.save.should be true
      saved = Product.first(:name => "Alice in Wonderland")
      expect(saved.stock).to eq(5)
      expect(saved.name).to eq("Alice in Wonderland")
    end
  end

  describe "given a record exists in the DB" do
    before :each do
      @record = Product.new(:name => "A Million Little Fibers", :stock => 4)
      @record.save!
      @id = @record.id
    end
    
    it "should request metadata for the record" do
      saved = Product.first(:name => "A Million Little Fibers")
      expect(saved.name).to eq("A Million Little Fibers")
      saved.stock.should be 4
    end
  end

  # it "should be able to request items with an offset" do
  #   @sdb.should_receive(:select).
  #     with(/count(\*).*LIMIT 10000/, anything).
  #     exactly(1).times.
  #     ordered.
  #     and_return(:next_token => "TOKEN")
  #   @sdb.should_receive(:select).
  #     with(anything, "TOKEN").
  #     exactly(1).times.
  #     ordered.
  #     and_return(:items => [])
  #   @record = Product.all(:offset => 10000, :limit => 10)
  # end

end
