require "test_helper"

describe "Plugin" do

  it "should expose a #seed_from_csv method on model instances" do
    db = Sequel.mock
    class MockModel < Sequel::Model(db); end
    refute_respond_to MockModel, :seed_from_csv
    MockModel.plugin :from_csv
    assert_respond_to MockModel, :seed_from_csv
  end

  it "should return self when #seed_from_csv is called" do
    pass
  end

  it "should raise not implemented for compound primary keys" do
    skip
  end

  it "should raise not implemented for missing primary keys" do
    skip
  end

  it "should raise missing field if primary key column is not in CSV" do
    skip
  end

  it "should insert new rows based on primary key" do
    skip
  end

  it "should update existing rows based on primary key" do
    skip
  end

  it "should delete missing rows when :delete_missing is enabled" do
    skip
  end

  it "should update the table's sequence if :reset_sequence is enabled" do
    skip
  end

end
