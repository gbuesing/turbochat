class AddCreatedAtToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :created_at, :datetime

    Message.update_all created_at: Time.now.utc
  end
end
