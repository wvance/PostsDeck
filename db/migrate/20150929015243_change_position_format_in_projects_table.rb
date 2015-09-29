class ChangePositionFormatInProjectsTable < ActiveRecord::Migration
  def up
    change_column :projects, :position, :integer
  end

  def down
    change_column :projects, :position, :string
  end
end
