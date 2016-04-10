class CreateContentAttachments < ActiveRecord::Migration
  def change
    create_table :content_attachments do |t|
      t.integer :content_id
      t.integer :user_id

      t.string :image
      t.string :description

      t.datetime :created
      t.datetime :updated

      t.timestamps null: false
    end
  end
end
