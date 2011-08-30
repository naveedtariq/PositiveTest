class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|

			t.string    :name,               :null => false
      t.string    :email,               :null => false
			t.integer		:facebook_id, 				:null => false

      t.timestamps
    end
		add_index :users, ["name"], :name => "index_users_on_name", :unique => true
    add_index :users, ["email"], :name => "index_users_on_email", :unique => true
  end

  def self.down
    drop_table :users
  end
end
