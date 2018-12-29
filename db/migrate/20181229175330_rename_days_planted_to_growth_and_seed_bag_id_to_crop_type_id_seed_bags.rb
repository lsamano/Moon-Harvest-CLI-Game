class RenameDaysPlantedToGrowthAndSeedBagIdToCropTypeIdSeedBags < ActiveRecord::Migration[5.0]
  def change
    rename_column :seed_bags, :days_planted, :growth
    rename_column :seed_bags, :seed_bag_id, :crop_type_id
  end
end
