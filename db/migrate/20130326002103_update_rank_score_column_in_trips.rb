class UpdateRankScoreColumnInTrips < ActiveRecord::Migration
  def up
    Trip.connection.execute("update trips set rank_score = 0")
  end

  def down
  end
end
