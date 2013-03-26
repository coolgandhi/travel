class ChangeRankScoreColumnToBigInt < ActiveRecord::Migration
  def up
    change_column :trips, :rank_score, :bigint
  end

  def down
  end
end
