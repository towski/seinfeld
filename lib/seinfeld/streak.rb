class Seinfeld
  # Represents a consecutive sequence of days that a user has committed.
  class Streak
    attr_accessor :started, :ended

    # start - First Date in the sequence that a commit was made.
    # ended - Last Date (or the current Date) in the sequence that a commit 
    #         was made.
    def initialize(started = nil, ended = nil)
      @started = started
      @ended   = ended || started
    end

    # Public: Counts the number of days in the sequence, including the start 
    # and end.
    def days
      if @started && @ended
        1 + (@ended - @started).to_i.abs
      else
        0
      end
    end

    # Public: Checks if the streak is current.  Allow streaks from yesterday 
    # to count, Seinfeld is confident the user will commit in time to keep 
    # the streak.
    #
    # date - The Date that we are checking against.  (default: Date.today)
    #
    # Returns true if the Streak is current, and false if it isn't.
    def current?(date = Date.today)
      @ended && (@ended + 1) >= date
    end

    # Public: Checks if the given date is included in the sequence.
    #
    # date - The Date that we are checking.
    #
    # Returns true if the date is in the Streak, and false if it isn't.
    def include?(date)
      if @started && @ended
        @started <= date && @ended >= date
      else
        false
      end
    end

    def inspect
      %(#{@started ? ("#{@started.year}-#{@started.month}-#{@started.day}") : :nil}..#{@ended ? ("#{@ended.year}-#{@ended.month}-#{@ended.day}") : :nil}:Streak)
    end
  end
end