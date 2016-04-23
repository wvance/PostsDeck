class AddLinkToService < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :link, :string
  end
end
