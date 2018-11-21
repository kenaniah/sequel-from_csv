require "test_helper"

describe "Gem" do
  it "should be registered as an extension" do
    assert_includes Sequel::Database::EXTENSIONS.keys, :from_csv
  end
  it "should expose a #seed_from_csv method on database instances" do
    db = Sequel.mock
    refute_respond_to db, :seed_from_csv
    db.extension :from_csv
    assert_respond_to db, :seed_from_csv
  end
end
