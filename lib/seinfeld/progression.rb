class Seinfeld
  class Progression < ActiveRecord::Base
    belongs_to :user
    
    def created_date
      return Date.today if !created_at
      Date.new(created_at.year, created_at.month, created_at.day)
    end
  end
end