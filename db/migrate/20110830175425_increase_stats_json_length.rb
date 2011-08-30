class IncreaseStatsJsonLength < ActiveRecord::Migration
  def self.up
		change_column :results, :stats_json, :string, :limit => 100000
  end

  def self.down
		change_column :results, :stats_json, :string, :limit => 255
  end
end
