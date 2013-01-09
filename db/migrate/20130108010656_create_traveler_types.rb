class CreateTravelerTypes < ActiveRecord::Migration
  def change
    create_table :traveler_types do |t|
      t.string :traveler_type_id
      t.string :traveler_type_name

      t.timestamps
    end
  end
end
