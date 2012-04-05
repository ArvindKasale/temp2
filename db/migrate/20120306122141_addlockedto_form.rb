class AddlockedtoForm < ActiveRecord::Migration
  def change
  	add_column :forms, :locked, :boolean, :default=> false
  end
end
