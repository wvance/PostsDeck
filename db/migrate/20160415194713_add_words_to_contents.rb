class AddWordsToContents < ActiveRecord::Migration[5.0]
  def change
    add_column :contents, :words, :text
  end
end
