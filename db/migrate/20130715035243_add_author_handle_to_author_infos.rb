class AddAuthorHandleToAuthorInfos < ActiveRecord::Migration
  def change
      add_column :author_infos, :author_handle, :string, :default => ""
  end
end
