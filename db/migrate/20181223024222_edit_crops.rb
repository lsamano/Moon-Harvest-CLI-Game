class EditCrops < ActiveRecord::Migration[5.0]
  def change
    drop_table :crops
  end
end
