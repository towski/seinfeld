class AddDisabledUsers < ActiveRecord::Migration
  def self.up
    add_column :seinfeld_users, :disabled, :boolean, :default => false
  end

  def self.down
    remove_column :seinfeld_users, :disabled, :boolean
  end
end
