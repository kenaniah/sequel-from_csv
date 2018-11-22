require 'csv'

module Sequel
  module Plugins
    module FromCsv

      class MissingDataException < StandardError; end
      class MissingFieldException < StandardError; end
      class NotYetImplementedException < StandardError; end

      module ClassMethods

        # Synchronizes a table's data with a CSV file. Returns self.
        #
        # The table being synchronized must contain exactly one primary key column, and the CSV file used
        # must contain the primary key column as one of its fields.
        #
        # +Options:+
        # :delete_missing :: whether to remove rows from the table that were not found in the CSV file
        # :reset_sequence :: whether to update the primary key's sequence to reflect the max primary key value
        #
        # :reset_sequence only works on PostgreSQL tables that auto-increment their primary keys using sequences
        #
        # +Usage:+
        #    class Artist < Sequel::Model
        #      plugin :from_csv
        #    end
        #    Artist.seed_from_csv "seeds/artists.csv", reset_sequence: true
        def seed_from_csv csv_path, delete_missing: false, reset_sequence: false

          # Read the source CSV file
          data = CSV.table csv_path, converters: :date_time

          # Guard against CSV files that have headers but not data (to handle a quirk in Ruby's CSV parser)
          if data.headers.empty?
            raise MissingDataException, "CSV file #{csv_path} did not contain any data rows"
          end

          # Check that all primary key columns are present
          pk = self.primary_key
          if Array === pk
            raise NotYetImplementedException, "Sequel::Plugins::FromCsv does not yet support composite primary keys."
          end

          # Ensure the ID column exists
          unless data.headers.include? pk
            raise MissingFieldException, "CSV file #{csv_path} must contain a column named '#{pk}'"
          end

          self.db.transaction do

            # UPSERT
            data.each do |row|
              row = row.to_h # Convert CSV::Row to Hash
              self.dataset.insert_conflict(target: pk, update: row).insert row
            end

            # DELETE old rows
            if delete_missing
              self.exclude(pk => data.map{|row| row[pk]}).delete
            end

            # Update the table's sequence
            if reset_sequence
              case self.db.database_type
              when :postgres
                self.db.run <<~SQL
                  SELECT
                    setval(pg_get_serial_sequence('#{self.simple_table}', '#{pk}'), greatest(max(#{pk}), 1), true)
                  FROM
                    #{self.simple_table}
                SQL
              end
            end

          end

          # Should return itself
          self

        end

      end

    end
  end
end
