class AddStatusToFriendAndRemoveFromUser < ActiveRecord::Migration
  def self.up
		add_column :facebook_statuses, :friend_id, :integer
		remove_column :facebook_statuses,:user_id
  end

  def self.down
		add_column :facebook_statuses, :user_id, :integer
		remove_column :facebook_statuses,:friend_id
  end
end
