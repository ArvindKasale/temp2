class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.string :title, :limit=>50
      t.integer :user_id
      t.integer :secret_key

      t.timestamps
    end
  end
end
