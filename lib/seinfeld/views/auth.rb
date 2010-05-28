class Seinfeld
  module Views
    class Auth < Layout
      def html_title
        'Calendar About Nothing'
      end

      alias page_title html_title
    end
  end
end
