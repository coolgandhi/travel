class AddRankScoreToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :rank_score, :integer
  end
end
