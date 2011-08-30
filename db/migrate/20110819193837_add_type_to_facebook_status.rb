class AddTypeToFacebookStatus < ActiveRecord::Migration
  def self.up
		add_column :facebook_statuses, :type, :string
  end

  def self.down
		remove_column :facebook_statuses, :type
  end
end
