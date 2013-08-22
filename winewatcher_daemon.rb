#!/usr/bin/env ruby

APP_CHECK_INTERVAL = 7

# move to a folder where the database can be written
Dir.chdir Dir.home

watcher = WineWatcher::Watcher.new
watcher.add_app(14322)
watcher.add_app(1424)
watcher.add_app(24498)
watcher.add_app(25823)

loop do
  watcher.check_next_app
  sleep(APP_CHECK_INTERVAL)
end
