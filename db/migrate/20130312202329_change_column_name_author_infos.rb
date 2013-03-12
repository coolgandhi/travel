class ChangeColumnNameAuthorInfos < ActiveRecord::Migration
  def up
    rename_column :author_infos, :blurb, :about
  end

  def down
    rename_column :author_infos, :about, :blurb
  end
end
