class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :author
      t.string :title
      t.string :image
      t.text :body
      
      t.string :position  # THIS TYPE IS CHANGED TO INTEGER

      t.string :technologies
      t.string :github_link
      t.string :project_link

      t.date :start
      t.date :end
      t.string :location
      t.datetime :created
      t.datetime :edited

      t.timestamps null: false
    end
  end
end
