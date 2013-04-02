class UpdateTravelerTypeForSoloTravelerToSolo < ActiveRecord::Migration
  def up
    TravelerType.connection.execute("update traveler_types set traveler_type_name ='Solo' where traveler_type_id='1'")
  end

  def down
  end
end
