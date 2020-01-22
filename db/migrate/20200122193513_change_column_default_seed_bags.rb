class ChangeColumnDefaultSeedBags < ActiveRecord::Migration[5.0]
  def change
    change_column_default :seed_bags, :growth, 0
    change_column_default :seed_bags, :watered, 0
    change_column_default :seed_bags, :harvested, 0
    change_column_default :seed_bags, :planted, 0
    change_column_default :seed_bags, :ripe, 0
  end
end
