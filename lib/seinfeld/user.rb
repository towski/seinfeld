class Seinfeld
  class User < ActiveRecord::Base
    has_many :progressions, :order => 'seinfeld_progressions.created_at'

    # Returns user's progress for a given month.
    #
    # Example
    #
    #   # find progressions from 5 days before and after April 2010.
    #   user.progress_for(2010, 4, 5)
    #
    # year  - Integer year to query.
    # month - Integer month to query.
    # extra - Number of days to pad on both sides.  (default: 0)
    #
    # Returns Array of Dates.
    def progress_for(year, month, extra = 0)
      beginning = Date.new(year, month)
      ending    = (beginning >> 1) - 1
      progressions.
        where(:created_at => (beginning - extra)..(ending + extra)).
        all.map { |p| p.created_date }
    end
  end
end