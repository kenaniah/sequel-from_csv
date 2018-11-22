require "minitest/autorun"
require "minitest/spec"
require "minitest/reporters"

require "pg"
require "sequel"
require "sequel-from_csv"
require "pry"

Minitest::Reporters.use!

class Minitest::Test
  parallelize_me!
end
