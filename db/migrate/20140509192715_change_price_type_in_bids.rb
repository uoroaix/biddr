class ChangePriceTypeInBids < ActiveRecord::Migration
  def change
    remove_column :bids, :price, :string
    add_column :bids, :price, :integer
  end
end
