require "test_helper"

describe "Plugin" do

  def with_connection

    return skip("No DATABASE_URL env variable defined") unless ENV['DATABASE_URL']

    @db ||= Sequel.connect ENV['DATABASE_URL']
    @random = rand 10000...10000

    @db.transaction rollback: :always do

      @db.run <<-SQL

        CREATE SCHEMA test_#{@random};

        -- A simple base table
        CREATE TABLE simple_#{@random}(
          id SERIAL PRIMARY KEY,
          name TEXT NOT NULL,
          is_active BOOLEAN,
          created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
        INSERT INTO simple_#{@random} (name, is_active) VALUES
          ('first', true),
          ('second', false)
        ;

        -- A namespaced table
        CREATE TABLE test_#{@random}.namespaced(
          key1 TEXT PRIMARY KEY,
          field1 INTERVAL,
          field2 TEXT
        );
        INSERT INTO test_#{@random}.namespaced VALUES
          ('one', null, 'val1'),
          ('two', null, 'val2'),
          ('three', '1 month', 'val3')
        ;

        -- A table with a compound key
        CREATE TABLE test_#{@random}.compound(
          key1 INTEGER NOT NULL,
          key2 INTEGER NOT NULL,
          field1 TEXT,
          PRIMARY KEY (key1, key2)
        );
        INSERT INTO test_#{@random}.compound VALUES
          (1, 1, 'a'),
          (1, 2, 'b'),
          (2, 2, 'c')
        ;

        -- A table with no keys
        CREATE TABLE test_#{@random}.keyless(
          field1 TEXT,
          field2 TEXT,
          UNIQUE (field1, field2)
        );
        INSERT INTO test_#{@random}.keyless VALUES
          ('a', 'one'),
          ('b', 'two'),
          ('a', 'three')
        ;

      SQL

      # Yield the transaction
      yield

    end

  end

  it "should expose a #seed_from_csv method on model instances" do
    db = Sequel.mock
    class MockModel < Sequel::Model(db); end
    refute_respond_to MockModel, :seed_from_csv
    MockModel.plugin :from_csv
    assert_respond_to MockModel, :seed_from_csv
  end

  it "should return self when #seed_from_csv is called" do
    with_connection do
      assert true
    end
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
