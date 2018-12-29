class AddPlantedColumnToCrops < ActiveRecord::Migration[5.0]
  def change
    add_column :crops, :planted, :integer
  end
end
