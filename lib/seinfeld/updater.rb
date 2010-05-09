class Seinfeld
  class Updater
    attr_reader :user

    def self.run(user, today = Date.today)
      new(user).run(today)
    end

    def initialize(user)
      @user = user
    end

    def run(today = Date.today)
      Time.zone = @user.time_zone || "UTC"
      if feed = Feed.fetch(@user.login)
        @user.update_progress(feed.committed_days, today)
      else
        @user.disabled = true
        @user.save!
      end
    end
  end
end