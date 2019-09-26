class CreateMessageTags < ActiveRecord::Migration[5.2]
  def change
    create_table :message_tags do |t|
      t.references :tag, foreign_key: true
      t.references :message, foreign_key: true

      t.timestamps
    end
  end
end
