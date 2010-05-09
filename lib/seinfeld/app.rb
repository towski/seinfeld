require 'sinatra/base'
require 'json'

class Seinfeld
  class App < Sinatra::Base
    error do
      e = request.env['sinatra.error']
    end

    configure do
      Seinfeld.configure
    end

    set :root,     Seinfeld.root
    set :app_file, __FILE__
    enable :static
    configure :development do
      enable  :show_exceptions, :dump_errors
      disable :raise_errors, :clean_trace
    end

    before do
      Time.zone = "UTC"
    end

    get '/' do
      cache_for 5.minutes
      @recent_users  = Seinfeld::User.best_current_streak
      @alltime_users = Seinfeld::User.best_alltime_streak
      haml :index
    end

    get '/~:name.json' do
      show_user_json
    end

    get '/~:name/widget' do
      if params[:name].present?
        @user = Seinfeld::User.find_by_login(params[:name].downcase)
      end
      if @user
        cache_for 1.hour
        haml :widget
      else
        redirect '/'
      end
    end

    get '/~:name' do
      show_user_calendar
    end

    get '/~:name/:year.json' do
      show_user_json
    end

    get '/~:name/:year' do
      show_user_calendar
    end

    get '/~:name/:year/:month.json' do
      show_user_json
    end

    get '/~:name/:year/:month' do
      show_user_calendar
    end

    get '/group/:names' do
      show_group_calendar
    end

    get '/group/:names/:year/:month' do
      show_group_calendar
    end

    helpers do
      include Seinfeld::CalendarHelper

      def page_title
        "%s's Calendar" % @user.login
      end

      def get_user_and_progressions(extra = 0, name = params[:name])
        return Set.new if name.blank?

        [:year, :month].each do |key|
          value       = params[key].to_i
          params[key] = value.zero? ? Date.today.send(key) : value
        end
        if @user = Seinfeld::User.find_by_login(name.downcase)
          Time.zone    = @user.time_zone || "UTC"
          progressions = @user.progress_for(params[:year], params[:month], extra)
        end
        Set.new(progressions || [])
      end

      def show_user_calendar
        @progressions = get_user_and_progressions(6)
        if @user
          cache_for 5.minutes
          haml :show
        else
          redirect "/"
        end
      end
  
      def show_group_calendar
        cache_for 5.minutes
        @progressions = Set.new
        @users = params[:names].split(',')
        @users.each do |name|
          @progressions.merge get_user_and_progressions(6, name)
        end
        haml :group
      end

      def show_user_json
        cache_for 5.minutes
        @progressions = get_user_and_progressions
        json = {:days => @progressions.map { |p| p.to_s }.sort!, :longest_streak => @user.longest_streak, :current_streak => @user.current_streak}.to_json
        if params[:callback]
          "#{params[:callback]}(#{json})"
        else
          json
        end
      end

      def link_to_user(user, streak_count = :current_streak)
        %(<a href="/~#{user.login}">#{user.login} (#{user.send(streak_count)})</a>)
      end

      def seinfeld
        now        = Date.new(params[:year], params[:month])
        prev_month = now << 1
        next_month = now >> 1
        calendar :year => now.year, :month => now.month,
          :previous_month_text => %(<a href="/~#{@user.login}/#{prev_month.year}/#{prev_month.month}">Previous Month</a>), 
          :next_month_text     => %(<a href="/~#{@user.login}/#{next_month.year}/#{next_month.month}" class="next">Next Month</a>) do |d|
          if @progressions.include? d
            [d.mday, {:class => "progressed"}]
          else
            [d.mday, {:class => "slacked"}]
          end
        end
      end
  
      def group_seinfeld
        now        = Date.new(params[:year], params[:month])
        prev_month = now << 1
        next_month = now >> 1
        calendar :year => now.year, :month => now.month,
          :previous_month_text => %(<a href="/group/#{params[:names]}/#{prev_month.year}/#{prev_month.month}">Previous Month</a>), 
          :next_month_text     => %(<a href="/group/#{params[:names]}/#{next_month.year}/#{next_month.month}" class="next">Next Month</a>) do |d|
          if @progressions.include? d
            [d.mday, {:class => "progressed"}]
          else
            [d.mday, {:class => "slacked"}]
          end
        end
      end

      def cache_for(time)
        response['Cache-Control'] = "public, max-age=#{time.to_i}"
      end
    end
  end
end