class CreateFacebookStatuses < ActiveRecord::Migration
  def self.up
    create_table :facebook_statuses do |t|
			t.string    :message
			t.integer :user_id
			t.string :raw_json
      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_statuses
  end
end
