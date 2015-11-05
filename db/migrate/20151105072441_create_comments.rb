class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :author
      t.string :email
      # t.integer :content_id
      t.text :body
      t.integer :parent_comment
      t.integer :score

      t.timestamps null: false
    end
  end
end
