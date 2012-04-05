class AddPositionToElement < ActiveRecord::Migration
  def change
    add_column :elements, :position, :integer
  end
end
