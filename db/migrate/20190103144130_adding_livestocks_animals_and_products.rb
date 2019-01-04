class AddingLivestocksAnimalsAndProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :animals do |t|
      t.string :species
      t.string :product_name
      t.integer :frequency
    end

    create_table :livestocks do |t|
      t.integer :farmer_id
      t.integer :animal_id
      t.string :name
      t.integer :love
      t.integer :brushed
      t.integer :got_product
      t.integer :fed
    end

    create_table :products do |t|
      t.string :livestock_id
      t.integer :sell_price
    end

    add_column :farmers, :barn_limit, :integer
  end
end
