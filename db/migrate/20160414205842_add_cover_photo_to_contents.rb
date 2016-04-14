class AddCoverPhotoToContents < ActiveRecord::Migration[5.0]
  def change
    add_column :contents, :has_cover_photo, :boolean, default: "false"
  end
end
