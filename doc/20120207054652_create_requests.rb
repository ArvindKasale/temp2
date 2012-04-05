class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :first_name
      t.string :last_name
      t.string :address_1
      t.string :address_2
      t.string :address_3
      t.string :pincode
      t.string :state
      t.string :country
      t.string :gender
      t.string :profession
      t.string :languages_known

      t.timestamps
    end
  end
end
