class CreateUserProviders < ActiveRecord::Migration
  def change
    create_table :user_providers do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret

      t.timestamps
    end
  end
end
