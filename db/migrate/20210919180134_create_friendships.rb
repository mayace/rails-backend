class CreateFriendships < ActiveRecord::Migration[6.1]
  def change
    create_table :friendships do |t|
      t.boolean :is_active
      t.references :sender, null: false
      t.references :receiver, null: false

      t.timestamps
    end
  end
end
