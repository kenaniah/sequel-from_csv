require 'csv'

module Sequel
  module Plugins
    module FromCsv

      class MissingFieldException < StandardError; end
      class NotYetImplementedException < StandardError; end

      module ClassMethods

        # Synchronizes a table's data with a CSV file
        def seed_from_csv csv_path, delete_missing: false, reset_sequence: true

          # Read the source CSV file
          data = CSV.table csv_path, converters: :date_time

          # Check that all primary key columns are present
          pk = self.primary_key
          if Array === pk
            raise NotYetImplementedException, "Sequel::Plugins::FromCsv does not yet support composite primary keys."
          end

          # Ensure the ID column exists
          unless data.first[pk]
            raise "CSV file #{csv_path} must contain a column named '#{pk}'"
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

        end

      end

    end
  end
end
