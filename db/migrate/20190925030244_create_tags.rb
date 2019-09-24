class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :tagname
      t.references :message, foreign_key: true

      t.timestamps
    end
  end
end
