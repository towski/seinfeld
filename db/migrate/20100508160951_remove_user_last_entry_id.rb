class RemoveUserLastEntryId < ActiveRecord::Migration
  def self.up
    remove_column :seinfeld_users, :last_entry_id
  end

  def self.down
    add_column :seinfeld_users, :last_entry_id, :string
  end
end
