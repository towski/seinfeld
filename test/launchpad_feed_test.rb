require File.join(File.dirname(__FILE__), "test_helper")

class LaunchpadFeedTest < ActiveSupport::TestCase
  data = feed_data(:launchpad,"atom")

  setup_once do
    @feed = Seinfeld::LaunchpadFeed.new :technoweenie, data
  end

  test "parses atom data" do
    assert_kind_of Seinfeld::LaunchpadFeed::Atom, @feed.atom
  end

  test "parses atom entries" do
    assert_equal 11, @feed.entries.size
  end

  test "parses entry published timestamp" do
    assert_equal Time.zone.local(2010, 05, 22, 07, 14, 15).to_date, @feed.entries[0].published_date
  end

  test "scans for committed days" do
    assert_equal [Date.civil(2010, 05, 22), Date.civil(2010, 05, 21)], @feed.committed_days
  end
end
