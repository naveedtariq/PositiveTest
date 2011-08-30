class AddBeneficialId < ActiveRecord::Migration
  def self.up
		add_column :twitter_users, :beneficial_id, :string
  end

  def self.down
		remove_column :twitter_users, :beneficial_id
  end
end
