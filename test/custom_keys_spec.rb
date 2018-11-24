require "test_helper"

describe "Custom keys" do

  around do |&block|

    DB.transaction rollback: :always do

      # Create temporary database objects
      DB.execute <<-SQL

        -- A quoted base table
        CREATE TABLE quoted_key_tests(
          "Strange, Quoted Key Field" SERIAL PRIMARY KEY,
          name TEXT NOT NULL,
          is_active BOOLEAN
        );
        INSERT INTO quoted_key_tests VALUES
          (1, 'first', true),
          (2, 'second', false),
          (5, 'fifth', true)
        ;
        SELECT setval('"quoted_key_tests_Strange, Quoted Key Field_seq"', 5, true);

      SQL

      # Create the test model
      class QuotedModel < Sequel::Model :quoted_key_tests
        plugin :from_csv
      end

      assert_equal 3, QuotedModel.count
      assert_equal :"Strange, Quoted Key Field", QuotedModel.primary_key

      # Yield the transaction
      super(&block)

    end

  end

  it "should properly handle primary keys with quoted names" do
    skip
  end

  it "should insert new rows based on primary key" do
    QuotedModel.seed_from_csv "test/seed/quoted.csv"
    assert_equal 4, QuotedModel.count
    assert_equal 'inserted', QuotedModel[3].name
  end

  it "should update existing rows based on primary key" do
    assert_equal 'second', QuotedModel[2].name
    QuotedModel.seed_from_csv "test/seed/quoted.csv"
    assert_equal 'updated', QuotedModel[2].name
  end

  it "should delete missing rows when :delete_missing is enabled" do

    # This should remain unchanged
    QuotedModel.seed_from_csv "test/seed/quoted_single_row.csv"
    assert_equal 3, QuotedModel.count

    # This should remove rows
    QuotedModel.seed_from_csv "test/seed/quoted_single_row.csv", delete_missing: true
    assert_equal 1, QuotedModel.count
    assert_equal 'first', QuotedModel[1].name
    assert_nil QuotedModel[2]
    assert_nil QuotedModel[5]

  end

  it "should update the table's sequence if :resequence is enabled" do

    def currval
      DB["SELECT currval('\"quoted_key_tests_Strange, Quoted Key Field_seq\"')"].first[:currval]
    end

    assert_equal 5, currval

    # These should be unchanged
    QuotedModel.seed_from_csv "test/seed/quoted_single_row.csv"
    assert_equal 5, currval

    QuotedModel.seed_from_csv "test/seed/quoted_single_row.csv", resequence: true
    assert_equal 3, QuotedModel.count
    assert_equal 5, currval

    QuotedModel.seed_from_csv "test/seed/quoted.csv", delete_missing: true
    assert_equal 5, currval

    # These should update to the last value
    QuotedModel.seed_from_csv "test/seed/quoted.csv", resequence: true
    assert_equal 3, currval

    QuotedModel.seed_from_csv "test/seed/quoted_single_row.csv", delete_missing: true, resequence: true
    assert_equal 1, currval

  end

end
