class RecreateCrops < ActiveRecord::Migration[5.0]
  def change
    create_table :crops do |t|
      t.integer :farmer_id
      t.integer :seed_id
      t.integer :days_planted
      t.integer :watered?
      t.integer :harvested?
    end
  end
end
