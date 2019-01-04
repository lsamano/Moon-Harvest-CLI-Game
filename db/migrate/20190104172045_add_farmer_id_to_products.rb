class AddFarmerIdToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :farmer_id, :integer
  end
end
