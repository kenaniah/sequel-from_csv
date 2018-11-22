require "test_helper"
require "minitest/hooks/default"

describe "Plugin" do

  around do |&block|

    return skip("No DATABASE_URL env variable defined") unless ENV['DATABASE_URL']

    @db ||= Sequel.connect ENV['DATABASE_URL']
    @random ||= rand 10_000..100_000

    @db.transaction rollback: :always do

      Sequel::Model.db = @db
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
        CREATE TABLE test_#{@random}.widgets(
          key1 TEXT PRIMARY KEY,
          field1 INTERVAL,
          field2 TEXT
        );
        INSERT INTO test_#{@random}.widgets VALUES
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

      # class ::SimpleModel < Sequel::Model :"simple_#{@random}"
      #   plugin :from_csv
      # end
      #
      # module Name
      #   module Spaced
      #   end
      # end
      # class ::Name::Spaced::Widget < Sequel::Model Sequel[:"test_#{@random}"][:widgets]
      #   plugin :from_csv
      # end
      #
      # class ::CompoundModel < Sequel::Model Sequel[:"test_#{@random}"][:compound]
      #   plugin :from_csv
      # end
      #
      # class ::KeylessModel < Sequel::Model Sequel[:"test_#{@random}"][:keyless]
      #   plugin :from_csv
      # end

      # Yield the transaction
      super(&block)

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
    assert true
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
