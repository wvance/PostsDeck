class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.string :title
      t.string :description
      t.string :image
      t.references :user, foreign_key: true
      t.string :position
      t.string :price
      t.string :image

      t.timestamps
    end
    add_index :services, :position
  end
end
