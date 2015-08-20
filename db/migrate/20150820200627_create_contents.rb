class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :title
      t.integer :author
      t.text :body
      t.string :image
      t.integer :external_id
      t.string :external_link
      t.string :kind
      t.string :rating
      t.string :location
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :postal
      t.string :ip
      t.string :latitude
      t.string :longitude
      t.boolean :is_active
      t.string :has_comments
      t.datetime :created
      t.datetime :updated

      t.timestamps null: false
    end
  end
end
