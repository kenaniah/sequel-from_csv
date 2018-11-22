require "test_helper"

describe "Plugin" do

  around do |&block|

    DB.transaction rollback: :always do

      # Create temporary database objects
      DB.execute <<-SQL

        -- A simple base table
        CREATE TABLE simple_tests(
          id SERIAL PRIMARY KEY,
          name TEXT NOT NULL,
          is_active BOOLEAN,
          created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
          defaulted INTEGER NOT NULL DEFAULT 42
        );
        INSERT INTO simple_tests (id, name, is_active) VALUES
          (1, 'first', true),
          (2, 'second', false),
          (5, 'fifth', true)
        ;
        SELECT setval('simple_tests_id_seq', 5, true);

      SQL

      # Create the test model
      class TestingModel < Sequel::Model :simple_tests
        plugin :from_csv
      end

      assert_equal 3, TestingModel.count
      assert_equal :id, TestingModel.primary_key

      # Yield the transaction
      super(&block)

    end

  end

  it "should expose a #seed_from_csv method on model instances" do
    db = Sequel.mock
    class MockModel < Sequel::Model db; end
    refute_respond_to MockModel, :seed_from_csv
    MockModel.plugin :from_csv
    assert_respond_to MockModel, :seed_from_csv
  end

  it "should return self when #seed_from_csv is called" do
    result = TestingModel.seed_from_csv "test/seed/simple.csv"
    assert_equal TestingModel, result
  end

  it "should leave the dataset unmodified if called with an unchanged file" do
    before = TestingModel.order(:id).all
    TestingModel.seed_from_csv "test/seed/simple_single_row.csv"
    after = TestingModel.order(:id).all
    assert_equal before, after
  end

  it "should insert new rows based on primary key" do
    TestingModel.seed_from_csv "test/seed/simple.csv"
    assert_equal 4, TestingModel.count
    assert_equal 'inserted', TestingModel[3].name
  end

  it "should update existing rows based on primary key" do
    assert_equal 'second', TestingModel[2].name
    TestingModel.seed_from_csv "test/seed/simple.csv"
    assert_equal 'updated', TestingModel[2].name
  end

  it "should delete missing rows when :delete_missing is enabled" do

    # This should remain unchanged
    TestingModel.seed_from_csv "test/seed/simple_single_row.csv"
    assert_equal 3, TestingModel.count

    # This should remove rows
    TestingModel.seed_from_csv "test/seed/simple_single_row.csv", delete_missing: true
    assert_equal 1, TestingModel.count
    assert_equal 'first', TestingModel[1].name
    assert_nil TestingModel[2]
    assert_nil TestingModel[5]

  end

  it "should update the table's sequence if :reset_sequence is enabled" do

    def currval
      DB["SELECT currval('simple_tests_id_seq')"].first[:currval]
    end

    assert_equal 5, currval

    # These should be unchanged
    TestingModel.seed_from_csv "test/seed/simple_single_row.csv"
    assert_equal 5, currval

    TestingModel.seed_from_csv "test/seed/simple_single_row.csv", reset_sequence: true
    assert_equal 3, TestingModel.count
    assert_equal 5, currval

    TestingModel.seed_from_csv "test/seed/simple.csv", delete_missing: true
    assert_equal 5, currval

    # These should update to the last value
    TestingModel.seed_from_csv "test/seed/simple.csv", reset_sequence: true
    assert_equal 3, currval

    TestingModel.seed_from_csv "test/seed/simple_single_row.csv", delete_missing: true, reset_sequence: true
    assert_equal 1, currval

  end

end
