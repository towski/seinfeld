dir = File.dirname(__FILE__)
$LOAD_PATH.unshift File.expand_path(dir)
$LOAD_PATH.unshift *Dir["#{dir}/../vendor/**/lib"]

require 'erb'
require 'logger'
require 'active_record' # v3

# Gives all the AR models their own tablenamespace:
#
#   seinfeld_*
#
class Seinfeld < ActiveRecord::Base
  class << self
    # String pointer to the root directory of the app.
    attr_accessor :root

    # ActiveSupport::StringInquirer instance of the current environment.  Set
    # by RACK_ENV or RAILS_ENV.
    attr_accessor :env

    # String path to the database.yml
    attr_accessor :db_config_path

    # String path to the location of the log directory.
    attr_accessor :log_path

    attr_reader :logger
  end

  [:Feed].each do |const|
    autoload const, "seinfeld/#{const.to_s.underscore}"
  end

  def self.logger
    @logger ||= begin
      file = path_from_root(log_path)
      FileUtils.mkdir_p File.dirname(file)
      Logger.new(file)
    end
  end

  # Public: Reads the database.yml config and starts up the connection to the
  # database.
  #
  # Returns nothing.
  def self.configure
    Time.zone = "UTC"
    path = path_from_root(db_config_path)
    yaml = ERB.new(IO.read(path)).result
    data = YAML.load(yaml)
    ActiveRecord::Base.establish_connection data[env.to_s]
    ActiveRecord::Base.logger = logger
  end

  # Either joins the given path with the Seinfeld.root as a base, or returns
  # the absolute path.
  #
  # path - Relative or absolute String path.
  #
  # Returns absolute String path.
  def self.path_from_root(path)
    path =~ /^\// ? path : File.join(root, path)
  end
end

Seinfeld.root           = File.expand_path(File.join(dir, '..'))
Seinfeld.env            = ActiveSupport::StringInquirer.new((ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development').to_s)
Seinfeld.db_config_path = 'config/database.yml'
Seinfeld.log_path       = "log/#{Seinfeld.env}.log"