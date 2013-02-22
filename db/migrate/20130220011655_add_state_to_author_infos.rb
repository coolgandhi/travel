class AddStateToAuthorInfos < ActiveRecord::Migration
  
  def change
    add_column :author_infos, :state, :string
    add_column :author_infos, :blurb, :string
  end

end
