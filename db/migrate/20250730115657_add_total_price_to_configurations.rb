class AddTotalPriceToConfigurations < ActiveRecord::Migration[8.0]
  def change
    add_column :configurations, :total_price, :decimal
  end
end
