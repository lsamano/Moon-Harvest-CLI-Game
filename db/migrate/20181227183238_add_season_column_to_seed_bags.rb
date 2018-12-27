class AddSeasonColumnToSeedBags < ActiveRecord::Migration[5.0]
  def change
     add_column :seed_bags, :season, :string
  end
end
