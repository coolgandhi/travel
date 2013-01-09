class CreateTransportTypes < ActiveRecord::Migration
  def change
    create_table :transport_types do |t|
      t.string : transport_type_id
      t.string :transport_name

      t.timestamps
    end
  end
end
