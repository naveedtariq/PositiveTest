class CreateAppStatuses < ActiveRecord::Migration
  def self.up
    create_table :app_statuses do |t|
			t.boolean :facebook_connected, :default => false
			t.boolean :fb_friends_fetched, :default => false
			t.boolean :fb_data_fetched, :default => false
			t.boolean :twt_data_fetched, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :app_statuses
  end
end
