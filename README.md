# Sequel - From CSV

[![Gem Version](https://badge.fury.io/rb/sequel-from_csv.svg)](http://badge.fury.io/rb/sequel-from_csv)
[![Build Status](https://secure.travis-ci.org/kenaniah/sequel-from_csv.svg)](http://travis-ci.org/kenaniah/sequel-from_csv)
[![Inline docs](http://inch-ci.org/github/kenaniah/sequel-from_csv.svg?branch=master)](http://inch-ci.org/github/kenaniah/sequel-from_csv)

Provides a simple way to seed and synchronize table data using CSV files.

## Installation

```bash
$ gem install sequel-from_csv
```

Or add this line to your application's Gemfile then execute `bundle install`:

```ruby
gem 'sequel-from_csv'
```

## Usage

To seed data for an individual model:

```ruby
# Load the plugin
Sequel::Model.plugin :from_csv

# Sync an individual model
class Country < Sequel::Model; end;
Country.seed_from_csv "app/models/country.csv"
```

To seed all models with CSV files present:

```ruby
# Load the extension
Sequel::Database.extension :from_csv

# Sync all models with CSV files recursively
DB.seed_from_csv "app/models/"
```
## To Do

 - [ ] Add tests
 - [ ] Remove the `activesupport` dependency
 - [ ] Allow custom primary key field names
 - [x] Wrap PostgreSQL-specific resequencing
 - [ ] Document optional arguments

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kenaniah/sequel-from_csv.
