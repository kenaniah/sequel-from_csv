require "test_helper"

describe "Extension" do

  it "should be registered as an extension" do
    assert_includes Sequel::Database::EXTENSIONS.keys, :from_csv
  end

  it "should expose a #seed_from_csv method on database instances" do
    db = Sequel.mock
    refute_respond_to db, :seed_from_csv
    db.extension :from_csv
    assert_respond_to db, :seed_from_csv
  end

  it "should return nil from #seed_from_csv" do
    db = Sequel.mock
    db.extension :from_csv
    assert_nil db.seed_from_csv "test/seed/empty/"
  end

  it "should seed all CSV files found within a directory" do
    skip
  end

  it "should seed all namespaced CSV files found within a directory" do
    skip
  end

end
