require "minitest/autorun"
require "minitest/spec"
require "minitest/reporters"

require "pg"
require "sequel"
require "sequel-from_csv"
require "logger"
require "pry"

Minitest::Reporters.use!

# This environment variable will be used by individual tests to connect the specified database
ENV['DATABASE_URL'] ||= 'postgres:///travis_ci_test'
DB = Sequel.connect ENV['DATABASE_URL']
DB.loggers << Logger.new(STDERR)
Sequel::Model.db = DB
