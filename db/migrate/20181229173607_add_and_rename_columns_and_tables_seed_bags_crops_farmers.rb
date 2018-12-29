class AddAndRenameColumnsAndTablesSeedBagsCropsFarmers < ActiveRecord::Migration[5.0]
  def change
    add_column :crops, :ripe, :integer

    rename_column :seed_bags, :seed_name, :crop_name
    rename_column :seed_bags, :price, :buy_price
    add_column :seed_bags, :sell_price, :integer

    add_column :farmers, :day, :integer
    add_column :farmers, :dog, :string
    add_column :farmers, :season, :string
    add_column :farmers, :money, :integer

    rename_table :seed_bags, :crop_types
    rename_table :crops, :seed_bags
  end
end
