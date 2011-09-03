class FixFbIdInFriends < ActiveRecord::Migration
  def self.up
		change_column :friends, :fb_id, :string
  end

  def self.down
		change_column :friends, :fb_id, :integer
  end
end
