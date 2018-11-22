require "minitest/autorun"
require "minitest/hooks/default"
require "minitest/reporters"
require "minitest/spec"

require "logger"
require "pg"
require "pry"
require "sequel"
require "sequel-from_csv"

Minitest::Reporters.use!

# This environment variable will be used by individual tests to connect the specified database
ENV['DATABASE_URL'] ||= 'postgres:///travis_ci_test'
DB = Sequel.connect ENV['DATABASE_URL']
DB.loggers << Logger.new('test/database.log')
Sequel::Model.db = DB
