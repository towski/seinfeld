require 'seinfeld'
require 'test/unit'
require 'active_support/test_case'
require 'running_man'
require 'yaml'

RunningMan.setup_on ActiveSupport::TestCase, :ActiveRecordBlock

class ActiveSupport::TestCase
  FEED_PATH = File.join(File.dirname(__FILE__), 'feeds')

  def feed_data(feed)
    IO.read File.join(FEED_PATH, "#{feed}.atom")
  end
end

begin
  require 'ruby-debug'
  Debugger.start
rescue LoadError
end