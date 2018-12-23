class CreateCrops < ActiveRecord::Migration[5.0]
  def change
    create_table :crops do |t|
      t.string :seed_name
      t.integer :days_to_grow
      t.integer :price
    end
  end
end
