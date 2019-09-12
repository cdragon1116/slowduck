class AddParentIdToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :parent_id, :integer, foreign_key: true
  end
end
