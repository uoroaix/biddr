class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.references :auction, index: true
      t.string :time
      t.string :price

      t.timestamps
    end
  end
end
