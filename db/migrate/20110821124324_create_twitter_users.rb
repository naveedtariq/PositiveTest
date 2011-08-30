class CreateTwitterUsers < ActiveRecord::Migration
  def self.up
    create_table :twitter_users do |t|

			t.string    :name
			t.string	  :screen_name
			t.boolean		:twt_fetched, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_users
  end
end
