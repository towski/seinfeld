require 'time'
require 'sax-machine'
require 'open-uri'

class Seinfeld
  class LaunchpadFeed
    # A Seinfeld::Feed::Atom reference to the parsed feed.
    attr_reader :atom

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
      url  = "http://github.com/#{login}.atom"
      open(url) { |f| feed = new(login, f.read, url) }
      feed
    end

    # Parses the given data with SAX Machine.
    #
    # data - String atom data.
    # url  - String url that was used.  (default: :direct)
    #
    # Returns Seinfeld::Feed.
    def initialize(login, data, url = :direct)
      @login = login.to_s
      @url   = url
      @atom  = Atom.parse(data)
    end

    # Public: Scans the parsed atom entries and pulls out all committed days.
    #
    # Returns Array of unique Date objects.
    def committed_days
      @committed_days ||= begin
        days = []
        entries.each do |entry|
          days << entry.published_date
        end
        days.uniq!
        days
      end
    end

    # Accesses each parsed atom entry.
    #
    # Returns an Array of Seinfeld::Feed::AtomEntry instances.
    def entries
      atom.entries
    end

    def inspect
      %(#<Seinfeld::Feed:#{@url} (#{entries.size})>)
    end

    class AtomEntry
      include SAXMachine
      element :published
      element :title
      element :author,  :as => :author_name

      def author
        @author ||= begin
          author_name.strip!
          author_name
        end
      end

      def published_at
        @published_at ||= Time.zone.parse(published)
      end

      def published_date
        Date.civil(published_at.year, published_at.month, published_at.day)
      end
    end

    class Atom
      include SAXMachine
      elements :entry, :as => :entries, :class => AtomEntry
    end
  end
end
