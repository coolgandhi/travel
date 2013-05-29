class AdjustTripAuthorIndex < ActiveRecord::Migration
  def up
  #  change_column :author_infos, :provider, :string, :default => "normal"
    remove_index :author_infos, :name=>'auth_email_index'
    add_index :author_infos, [:email, :provider], :name=>'auth_email_index', :unique => true
  end

  def down
  end
end
