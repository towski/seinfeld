class Seinfeld
  module Views
    class Layout < Mustache
      def html_title
        s = 'Calendar About Nothing'
        if login = @login || (@user && @user.login)
          s.replace "#{login}'s #{s}"
        end
        s
      end

      def anon
        !@user
      end

      def user
        @user
      end

      def user_current_streak
        @user && @user.current_streak
      end

      def user_longest_streak
        @user && @user.longest_streak
      end

      def user_longest_streak_url
        @user && @user.longest_streak_url
      end
    end
  end
end
