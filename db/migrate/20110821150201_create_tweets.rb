class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
			t.string :unique_twitter_id
			t.string :message
			t.string :raw_json
			t.integer :twitter_user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end
