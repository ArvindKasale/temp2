class AddMiddleNameToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :middle_name, :string
  end
end
