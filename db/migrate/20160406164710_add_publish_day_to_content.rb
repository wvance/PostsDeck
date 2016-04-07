class AddPublishDayToContent < ActiveRecord::Migration
  def change
    add_column :contents, :publish_at, :datetime
  end
end
