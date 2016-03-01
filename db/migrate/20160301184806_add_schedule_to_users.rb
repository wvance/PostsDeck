class AddScheduleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :calendly, :string
  end
end
