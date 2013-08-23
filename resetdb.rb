#!/usr/bin/env ruby
# This script will reset the database to notify that 2 apps have new
# test results by giving them some dates than are older than the ones
# currently given in AppDB.

# Note: in order for the test to work, the app id's must be the same as
# some of the one's being watched in the daemon

require 'date'
require 'moneta'
require './winewatcher'

Dir.chdir Dir.home
File.delete 'winewatcher.db' if File.exist? 'winewatcher.db'

store = Moneta.new(:Daybreak, :file => "winewatcher.db")
store[1424] = {
  app_name: "Adobe Illustrator",
  test_date: Date.parse('Apr 17 2009')
}
store[25823] = {
  app_name: "EVE Online",
  test_date: Date.parse('Jul 30 2012')
}
store.close
