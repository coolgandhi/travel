class AddPasswordExpireAtToAuthorInfos < ActiveRecord::Migration
  def change
    add_column :author_infos, :password_expire_at, :datetime
  end
end
