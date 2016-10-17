class CreateHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :histories do |t|
      t.references :toy, index: false, null: false
      t.references :cat, index: true, null: false
      t.integer :rate, null: false, default: 0
      t.string :comment

      t.timestamps
    end
    add_index :histories, [:toy_id, :cat_id], unique: true
  end
end
