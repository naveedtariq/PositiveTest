class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
			t.integer :user_id
			t.string :user_type
			t.integer :positive_score
			t.integer :negative_score
			t.integer :score
			t.string :stats_json
			t.integer :messages_count
      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end
