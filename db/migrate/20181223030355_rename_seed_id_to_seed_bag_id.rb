class RenameSeedIdToSeedBagId < ActiveRecord::Migration[5.0]
  def change
    rename_column :crops, :seed_id, :seed_bag_id
  end
end
