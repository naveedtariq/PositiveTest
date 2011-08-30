class AddUniqueFbIdToStatus < ActiveRecord::Migration
  def self.up
		add_column :facebook_statuses, :unique_fb_id, :string
  end

  def self.down
		remove_column :facebook_statuses,:unique_fb_id
  end
end
