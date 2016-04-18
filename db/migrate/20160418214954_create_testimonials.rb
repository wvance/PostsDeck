class CreateTestimonials < ActiveRecord::Migration[5.0]
  def change
    create_table :testimonials do |t|
      t.references :user, foreign_key: true
      t.string :summary
      t.string :body
      t.string :author
      t.string :link
      t.string :image
      t.datetime :created

      t.timestamps
    end
  end
end
