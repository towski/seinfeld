require File.join(File.dirname(__FILE__), "test_helper")

class FeedTest < ActiveSupport::TestCase
  data = feed_data(:simple)

  setup_once do
    @feed = Seinfeld::Feed.new :technoweenie, data
  end

  test "parses atom data" do
    assert_kind_of Seinfeld::Feed::Atom, @feed.atom
  end

  test "parses atom entries" do
    assert_equal 9, @feed.entries.size
  end

  test "parses entry published timestamp" do
    assert_equal Time.zone.local(2009, 12, 19, 14, 42, 13), @feed.entries[0].published_at
  end

  test "scans for committed days" do
    assert_equal [
      Date.civil(2009, 12, 19),
      Date.civil(2009, 12, 17),
      Date.civil(2009, 12, 16),
      Date.civil(2009, 12, 15)], @feed.committed_days
  end
end