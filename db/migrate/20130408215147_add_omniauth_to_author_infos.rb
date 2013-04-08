class AddOmniauthToAuthorInfos < ActiveRecord::Migration
  def change
    add_column :author_infos, :provider, :string
    add_column :author_infos, :uid, :string
  end
end
