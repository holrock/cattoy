class CreateHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :histories do |t|
      t.references :toy, index: true, null: false
      t.references :cat, index: true, null: false, default: 0
      t.integer :rate, null: false
      t.string :comment

      t.timestamps
    end
  end
end
