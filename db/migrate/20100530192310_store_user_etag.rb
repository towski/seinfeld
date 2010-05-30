class StoreUserEtag < ActiveRecord::Migration
  def self.up
    add_column :seinfeld_users, :etag, :string
  end

  def self.down
    remove_column :seinfeld_users, :etag
  end
end
