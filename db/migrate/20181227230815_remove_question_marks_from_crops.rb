class RemoveQuestionMarksFromCrops < ActiveRecord::Migration[5.0]
  def change
    rename_column :crops, :watered?, :watered
    rename_column :crops, :harvested?, :harvested
  end
end
