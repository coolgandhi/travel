class AddImageToAuthorInfo < ActiveRecord::Migration
  def change
    add_column :author_infos, :self_image, :text
    add_column :author_infos, :self_image_tmp,  :text
  end
end
