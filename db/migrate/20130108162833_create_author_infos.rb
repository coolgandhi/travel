class CreateAuthorInfos < ActiveRecord::Migration
  def change
    create_table :author_infos do |t|
      t.string :author_id
      t.string :author_handle 
      t.string :author_name
      t.string :bithday
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :city
      t.string :country
      t.string :postal_code
      t.string :phone
      t.string :email
      t.string :website
      t.string :twitter_handle

      t.timestamps
    end
  end
end
