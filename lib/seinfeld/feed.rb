require 'time'
require 'open-uri'
require 'yajl'

class Seinfeld
  class Feed
    # A Array of Hashes of the parsed event JSON.
    attr_reader :items

    # The String GitHub account name.
    attr_reader :login

    # The String url that the atom feed was fetched from (default: :direct)
    attr_reader :url

    # Public: Downloads a user's public feed from GitHub.
    #
    # login - String login name from GitHub.
    # 
    # Returns Seinfeld::Feed instance.
    def self.fetch(login)
      feed = nil
      url  = "http://github.com/#{login}.json"
      open(url) { |f| feed = new(login, f.read, url) }
      feed
    rescue OpenURI::HTTPError => e
      if e.message =~ /404/
        nil
      else
        # some other error?
        new(login, "[]", url)
      end
    end

    # Parses the given data with Yajl.
    #
    # login - String login of the user being scanned.
    # data  - String JSON data.
    # url   - String url that was used.  (default: :direct)
    #
    # Returns Seinfeld::Feed.
    def initialize(login, data, url = :direct)
      @login = login.to_s
      @url   = url
      @items = Yajl::Parser.parse(data)
    end

    # Public: Scans the parsed atom entries and pulls out all committed days.
    #
    # Returns Array of unique Date objects.
    def committed_days
      @committed_days ||= begin
        days = []
        items.each do |item|
          self.class.committed?(item) && 
            days << Time.zone.parse(item['created_at']).to_date
        end
        days.uniq!
        days
      end
    end

    VALID_EVENTS = %w(PushEvent CommitEvent ForkApplyEvent)

    # Determines whether the given entry counts as a commit or not.
    #
    # item - Hash containing the data for one event.
    #
    # Returns true if the entry is a commit, and false if it isn't.
    def self.committed?(item)
      type = item['type']
      VALID_EVENTS.include?(type) || (
        type == 'CreateEvent' && item['payload'] && item['payload']['object'] == 'branch')
    end

    def inspect
      %(#<Seinfeld::Feed:#{@url} (#{items.size})>)
    end
  end
end