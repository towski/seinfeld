require 'seinfeld'
require 'test/unit'
require 'active_support/test_case'
require 'running_man'
require 'yaml'

RunningMan.setup_on ActiveSupport::TestCase, :ActiveRecordBlock

class ActiveSupport::TestCase
  FEED_PATH = File.join(File.dirname(__FILE__), 'feeds')

  def self.feed_data(feed)
    IO.read File.join(FEED_PATH, "#{feed}.atom")
  end

  def feed_data(feed)
    self.class.feed_data(feed)
  end
end

Seinfeld.configure('test')
Time.zone = 'Pacific Time (US & Canada)'

begin
  require 'ruby-debug'
  Debugger.start
rescue LoadError
end