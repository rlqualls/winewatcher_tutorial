#!/usr/bin/env ruby

# The number of seconds between checking each app.
# In actual use, this number should be much higher. There's no reason to hit
# WineHQ more often than once every 10-60 minutes, as Test Results aren't
# submitted that often.
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
