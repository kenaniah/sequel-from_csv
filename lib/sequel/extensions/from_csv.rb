module Sequel
  module Extensions
    module FromCsv

      # Finds all CSV files in a directory and synchronizes with their respective DB tables
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
  Database.register_extension(:from_csv, Extensions::FromCsv)
end
