require "test_helper"

describe "Custom keys" do

  around do |&block|

    DB.transaction rollback: :always do

      # Yield the transaction
      super(&block)

    end

  end

  it "should properly handle primary keys with quoted names" do
    skip
  end

end
