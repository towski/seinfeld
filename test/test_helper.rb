require 'seinfeld'
require 'test/unit'
require 'active_support/test_case'
require 'running_man'
require 'yaml'

RunningMan.setup_on ActiveSupport::TestCase, :ActiveRecordBlock

begin
  require 'ruby-debug'
  Debugger.start
rescue LoadError
end