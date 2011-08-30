class FixTypeColumnNameInStatus < ActiveRecord::Migration
  def self.up
		rename_column :facebook_statuses, :type, :feed_type
  end

  def self.down
		rename_column :facebook_statuses, :feed_type, :type
  end
end
