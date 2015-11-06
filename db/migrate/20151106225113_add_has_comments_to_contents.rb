class AddHasCommentsToContents < ActiveRecord::Migration
  def change
    add_column :contents, :has_comments, :boolean
  end
end
