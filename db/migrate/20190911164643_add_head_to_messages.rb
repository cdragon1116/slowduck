class AddHeadToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :head, :boolean, default: false
  end
end
