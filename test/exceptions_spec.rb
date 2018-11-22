require "test_helper"

describe "Custom keys" do

  around do |&block|

    DB.transaction rollback: :always do

      # Yield the transaction
      super(&block)

    end

  end

  it "should raise missing data when the CSV file does not contain data rows" do
    skip
  end

  it "should raise not implemented when the key column is not present in the CSV" do
    skip
  end

  it "should raise not implemented when no primary key is present" do
    skip
  end

  it "should raise not implemented when compound primary keys are used" do
    skip
  end

  it "should raise not implemented when resequencing columns that are not backed by a sequence" do
    skip
  end

end
