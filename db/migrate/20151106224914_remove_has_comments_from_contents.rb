class RemoveHasCommentsFromContents < ActiveRecord::Migration
  def change
    remove_column :contents, :has_comments, :string
  end
end
