class AddUserToTwitterUser < ActiveRecord::Migration
  def change
    add_column :twitter_users, :user_id, :integer
  end
end
