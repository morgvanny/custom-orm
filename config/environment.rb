require 'bundler'
Bundler.require

DBCONN = SQLite3::Database.new('db/basketball.db')

DBCONN.results_as_hash = true

require_relative '../lib/player.rb'
require_relative '../lib/team.rb'
