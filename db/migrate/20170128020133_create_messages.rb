class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.belongs_to :room, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.string :body
    end
  end
end
