class DropMessageIdFromTags < ActiveRecord::Migration[5.2]
  def change
    remove_column :tags, :message_id
  end
end
