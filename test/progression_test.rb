require File.join(File.dirname(__FILE__), "test_helper")

class ProgressionTest < ActiveSupport::TestCase
  fixtures do
    @user = Seinfeld::User.create! :login => 'bob'
    @user.progressions.create!(:created_at => Date.new(2008, 1, 1))
    @user.progressions.create!(:created_at => Date.new(2008, 1, 30))
    @user.progressions.create!(:created_at => Date.new(2008, 1, 31))
    @user.progressions.create!(:created_at => Date.new(2008, 2, 1))
    @user.progressions.create!(:created_at => Date.new(2008, 2, 2))
    @user.progressions.create!(:created_at => Date.new(2008, 3, 1))
    @user.progressions.create!(:created_at => Date.new(2008, 3, 2))
  end

  test "#progress_for(year, month) finds progress for a given calendar month" do
    progressions = @user.progress_for 2008, 2
    assert  progressions.include?(Date.new(2008, 2, 1))
    assert  progressions.include?(Date.new(2008, 2, 2))
    assert !progressions.include?(Date.new(2008, 2, 3))
    assert !progressions.include?(Date.new(2008, 1, 1))
    assert !progressions.include?(Date.new(2008, 1, 30))
    assert !progressions.include?(Date.new(2008, 1, 31))
    assert !progressions.include?(Date.new(2008, 3, 1))
    assert !progressions.include?(Date.new(2008, 3, 2))
  end

  test "#progress_for(year, month, 1) finds progress for a given calendar month with an extra padded day" do
    progressions = @user.progress_for 2008, 2, 1
    assert  progressions.include?(Date.new(2008, 1, 31))
    assert  progressions.include?(Date.new(2008, 2, 1))
    assert  progressions.include?(Date.new(2008, 2, 2))
    assert  progressions.include?(Date.new(2008, 3, 1))
    assert !progressions.include?(Date.new(2008, 2, 3))
    assert !progressions.include?(Date.new(2008, 3, 2))
    assert !progressions.include?(Date.new(2008, 1, 1))
    assert !progressions.include?(Date.new(2008, 1, 30))
  end
end