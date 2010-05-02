require ::File.dirname(__FILE__) + "/lib/seinfeld.rb"

Seinfeld::App.set :environment, ENV['RACK_ENV'] || ENV['RAILS_ENV'] || :production
run Seinfeld::App
