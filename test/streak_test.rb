require File.join(File.dirname(__FILE__), "test_helper")

class StreakTest < ActiveSupport::TestCase
  setup_once do
    @today         = Date.today
    @new_streak    = Seinfeld::Streak.new
    @same_streak   = Seinfeld::Streak.new(Date.civil(2008, 1, 5))
    @set_streak    = Seinfeld::Streak.new(Date.civil(2007, 12, 31), Date.civil(2008, 1, 5))
    @today_streak  = Seinfeld::Streak.new(@today - 4, @today)
    @yester_streak = Seinfeld::Streak.new(@today - 5, @today-1)
    @old_streak    = Seinfeld::Streak.new(@today - 6, @today-2)
  end

  test "has 0 days with neither bounds set" do
    assert_equal 0, @new_streak.days
  end

  test "does not include outside date with neither bounds set" do
    assert !@new_streak.include?(@today)
  end

  test "is not current with neither bounds set" do
    assert !@new_streak.current?
  end

  test "has 1 day with @started and @ended set on the same day" do
    assert_equal 1, @same_streak.days
  end

  test "does not include outside date with @started and @ended set on the same day" do
    assert !@same_streak.include?(@today)
  end

  test "is not current with @started and @ended set on the same day" do
    assert !@same_streak.current?
  end

  test "has 5 days with @started and @ended set, ending today" do
    assert_equal 5, @today_streak.days
  end

  test "is current with @started and @ended set, ending today" do
    assert @today_streak.current?
  end

  test "has 5 days with @started and @ended set, ending yestertoday" do
    assert_equal 5, @yester_streak.days
  end

  test "is current with @started and @ended set, ending yestertoday" do
    assert @yester_streak.current?
  end

  test "has 5 days with @started and @ended set, ending 2 days ago" do
    assert_equal 5, @old_streak.days
  end

  test "is not current with @started and @ended set, ending 2 days ago" do
    assert !@old_streak.current?
  end
end