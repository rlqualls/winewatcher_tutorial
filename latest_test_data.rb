#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'
require 'date'

app_id = ARGV[0]
app_url = "http://appdb.winehq.org/objectManager.php?sClass=version&iId=#{app_id}"

doc = Nokogiri::HTML(open(app_url))

# Get app name
name = doc.css("[text()*='Name']")[0].parent.next_element.text

# Get latest test data
result_rows = doc.css(".historyTable tr")
latest_result = result_rows[1]
latest_columns = latest_result.css("td")
distro = latest_columns[1].text
test_date = Date.parse(latest_columns[2].text)
wine_version = latest_columns[3].text
rating = latest_columns[6].text

puts "name:   #{name}"
puts "distro: #{distro}"
puts "date:   #{test_date}"
puts "wine:   #{wine_version}"
puts "rating: #{rating}"

