class AddStickyToContents < ActiveRecord::Migration
  def change
    add_column :contents, :is_sticky, :boolean, default: false
  end
end
