class CreateChatroomUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :chatroom_users do |t|
      t.references :user, foreign_key: true
      t.references :chatroom, foreign_key: true
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
