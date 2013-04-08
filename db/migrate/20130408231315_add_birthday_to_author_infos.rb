class AddBirthdayToAuthorInfos < ActiveRecord::Migration
  def change
    add_column :author_infos, :birthday, :date
    remove_column :author_infos, :bithday
  end
end
