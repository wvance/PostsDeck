class AddAuthorTitleToCreateTestimonials < ActiveRecord::Migration[5.0]
  def change
    add_column :testimonials, :author_title, :string
    add_column :testimonials, :author_company, :string
  end
end
