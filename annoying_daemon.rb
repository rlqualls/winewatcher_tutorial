# annoying_daemon.rb
require 'libnotify'

adv = ["basically", "just", "entirely", "practically"]
nouns = ["Doctors", "Lawyers", "Dermatologists", "Ruby Consultants"]
adj = ["angry", "mad", "furious", "outraged", "livid"] 
poss = ["her", "his", "area man's", "this mom's"]

# Show a 3-second notification every 10 seconds
loop do
  annoy_str = "They're #{adv.sample} #{adj.sample} about #{poss.sample} secret"
  Libnotify.show(:summary => nouns.sample, 
                  :body => annoy_str, 
                  :timeout => 3)
  sleep(10)
end
