class AddCounterToLivestocksAndRenameBarnLimitToBarnCount < ActiveRecord::Migration[5.0]
  def change
    rename_column :farmers, :barn_limit, :barn_count
    add_column :livestocks, :counter, :integer
  end
end
