class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :seinfeld_users, :disabled
    add_index :seinfeld_progressions, :user_id
  end

  def self.down
    remove_index :seinfeld_users, :disabled
    remove_index :seinfeld_progressions, :user_id
  end
end
