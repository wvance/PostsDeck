class AddContentIdRefToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :content, index: true
    add_foreign_key :comments, :contents
  end
end
