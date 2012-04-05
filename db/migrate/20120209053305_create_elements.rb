class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.string :width
      t.string :height
      t.string :name
      t.string :input
      t.integer :length
      t.string :entries
      t.integer :category_id
      t.integer :form_id

      t.timestamps
    end
  end
end
