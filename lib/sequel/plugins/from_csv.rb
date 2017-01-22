require 'csv'

module Sequel
  module Plugins
    module FromCsv
      module ClassMethods

        # Synchronizes a table's data with a CSV file
        def seed_from_csv csv_path, delete_missing: false, reset_sequence: true

          # Read the source CSV file
          data = CSV.table csv_path

          # Ensure the ID column exists
          unless data.first[:id]
            raise "CSV file #{csv_path} must contain an id column"
          end

          self.db.transaction do

            # UPSERT
            data.each do |row|
              row = row.to_h # Convert CSV::Row to Hash
              self.dataset.insert_conflict(target: :id, update: row).insert row
            end

            # DELETE old rows
            if delete_missing
              self.exclude("id IN ?", data.map{|row| row[:id]}).delete
            end

            # Update the table's sequence
            if reset_sequence case self.db.database_type
            when :postgres
              self.db.run <<~SQL
                SELECT
                  setval(pg_get_serial_sequence('#{self.simple_table}', 'id'), coalesce(max(id), 1), true)
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
