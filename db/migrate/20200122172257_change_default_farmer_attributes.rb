class ChangeDefaultFarmerAttributes < ActiveRecord::Migration[5.0]
  def change
    change_column_default :farmers, :day, 1
    change_column_default :farmers, :season, "fall"
    change_column_default :farmers, :money, 2000
    change_column_default :farmers, :barn_count, 2
  end
end
