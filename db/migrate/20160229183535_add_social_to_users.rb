class AddSocialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :github, :string
    add_column :users, :linkedin, :string
    add_column :users, :facebook, :string
  end
end
