require "test_helper"

describe "Plugin" do
  it "should be exposed as an extension" do
    assert_includes Sequel::Database::EXTENSIONS.keys, :from_csv
  end
end
