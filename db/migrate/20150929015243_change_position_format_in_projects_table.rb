class ChangePositionFormatInProjectsTable < ActiveRecord::Migration
  def up
    change_column :projects, :position, 'integer USING CAST(column_name AS integer)'
  end

  def down
    change_column :projects, :position, :string
  end
end
