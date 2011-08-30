class AddFetchedToFriend < ActiveRecord::Migration
  def self.up
		add_column :friends, :fb_fetched, :boolean, :default => false
  end

  def self.down
		remove_column :friends, :fb_fetched
  end
end
