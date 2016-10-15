class CreateToys < ActiveRecord::Migration[5.0]
  def change
    create_table :toys do |t|
      t.text :name
      t.text :description
      t.text :url
      t.text :image_url

      t.timestamps
    end
  end
end
