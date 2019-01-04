class MoveSellPriceToAnimalsAndRemoveGotProductFromLivestocks < ActiveRecord::Migration[5.0]
  def change
    add_column :animals, :sell_price, :integer
    remove_column :products, :sell_price
    remove_column :livestocks, :got_product
  end
end
