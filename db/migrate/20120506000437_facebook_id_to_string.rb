class FacebookIdToString < ActiveRecord::Migration
  def up
    change_column :users, :facebook_id, :string
    change_column :friends, :fb_id, :string
  end

  def down
    change_column :users, :facebook_id, :integer
    change_column :friends, :fb_id, :integer
  end
end
