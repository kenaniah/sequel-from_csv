module Sequel
  module Extensions
    module FromCsv

      # Finds all CSV files recursively within a directory and calls #seed_from_csv on their respective models
      #
      # Calling #seed_from_csv with a directory contaning:
      # - artists.csv
      # - artist/has_albums.csv
      #
      # Would be equivalent to calling:
      #   Artist.seed_from_csv "artists.csv"
      #   Artist::HasAlbum.seed_from_csv "artist/has_albums.csv"
      #
      # +Options:+
      # :delete_missing :: whether to remove rows from the table that were not found in the CSV file
      # :reset_sequence :: whether to update the primary key's sequence to reflect the max primary key value
      #
      # :reset_sequence only works on PostgreSQL tables that auto-increment their primary keys using sequences
      def seed_from_csv directory, **opts

        Dir.glob("#{directory}/**/*.csv").each do |filename|

          klass = filename.sub "#{directory}", ""
          klass = klass[1..-1] if klass.starts_with? "/"
          klass = klass.split(".")[0]

          model = klass.classify.constantize
          model.plugin :from_csv
          model.seed_from_csv filename, **opts

        end

        nil

      end

    end
  end
  Database.register_extension :from_csv, Extensions::FromCsv
end
