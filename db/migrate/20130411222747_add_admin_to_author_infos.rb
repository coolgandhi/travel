class AddAdminToAuthorInfos < ActiveRecord::Migration
  def change
    add_column :author_infos, :admin, :boolean, :default => false
  end
end
