class DropTimeColumnFromBids < ActiveRecord::Migration
  def change
    remove_column :bids, :time, :string
  end
end
