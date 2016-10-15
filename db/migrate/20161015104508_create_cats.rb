class CreateCats < ActiveRecord::Migration[5.0]
  def change
    create_table :cats do |t|
      t.string :name, null: false
      t.references :user, index: true
      t.text :image_url

      t.timestamps
    end
  end
end
