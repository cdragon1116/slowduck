class AddColorToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :color, :integer
  end
end
