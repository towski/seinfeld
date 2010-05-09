class IndexUserLogin < ActiveRecord::Migration
  def self.up
    add_index :seinfeld_users, :login, :unique => true
  end

  def self.down
    remove_index :seinfeld_users, :login
  end
end
