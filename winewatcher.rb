#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'
require 'libnotify'
require 'moneta'
require 'date'

module WineWatcher

  class TestResult
    attr_accessor :app_name, :distribution, :test_date, :wine_version, :rating

    def hash_result
      {
        app_name: @app_name,
        test_date: @test_date
      }
    end

    def to_s
      "App: #{@app_name}\nDistribution: #{@distribution}\nDate: #{@test_date}\n" + 
      "Wine Version: #{@wine_version}\nRating: #{@rating}\n"
    end
  end

  class Watcher

    BASE_URL = "http://appdb.winehq.org/objectManager.php?sClass=version&iId="
    NOTIFY_RESULT_EXPIRATION = 0
    NOTIFY_WATCH_EXPIRATION = 2
    MIN_ACCESS_INTERVAL = 2
    
    def initialize
      @dates = {}
      @apps = []
      @app_index = 1
      @results = Moneta.new(:Daybreak, :file => "winewatcher.db")
    end

    # To use a different notification system, just change the call here
    def notify(summary, body, timeout)
      Libnotify.show(:summary => summary, 
                    :body => body,
                    :timeout => timeout)
    end

    # Only add apps not already being watched
    # Notify user the name of the app
    def add_app(app_id)
      if !@apps.include?(app_id)
        @apps << app_id
        if (!@results.key?(app_id))
          latest_result = get_latest_result(app_id)
          @results[app_id] = latest_result.hash_result
          sleep MIN_ACCESS_INTERVAL
        end
        notify("WineWatcher", 
              "Watching #{@results[app_id][:app_name]}",
              NOTIFY_WATCH_EXPIRATION)
      end
    end

    # If the most recent date is newer than the one in the database,
    # Notify the user and update the date
    def check_next_app
      app_id  = @apps[@app_index % @apps.size]
      latest_result = get_latest_result(app_id)
      if (latest_result.test_date > @results[app_id][:test_date])
        notify("WineWatcher: New Test Result", 
              latest_result.to_s,
              NOTIFY_RESULT_EXPIRATION)
        # wasteful to assign whole hash but assigning keys doesn't seem to work
        @results[app_id] = latest_result.hash_result
      end
      @app_index += 1
    end

    # Pull all of the information needed from AppDB for a test result
    def get_latest_result(app_id)
      url = BASE_URL + app_id.to_s
      doc = Nokogiri::HTML(open(url))
      row = doc.css(".historyTable tr")[1]
      columns = row.css("td")
      app_name = doc.search("[text()*='Name']")[0].parent.next_element.text.strip
      result = TestResult.new
      result.app_name = app_name
      result.distribution = columns[1].text.strip
      result.test_date = Date.parse(columns[2].text.strip)
      result.wine_version = columns[3].text.strip
      result.rating = columns[6].text.strip
      return result
    end 

  end
end
