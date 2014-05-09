class Bid < ActiveRecord::Base

  belongs_to :auction
  belongs_to :user

  validate :check_bid_price, on: :create
  validate :check_user, on: :create

  delegate :current_price, to: :auction
  delegate :reserve_price, to: :auction
  delegate :full_name, to: :user  
  delegate :title, to: :auction


  scope :sort_by_desc, -> {order("created_at DESC")}

  def check_bid_price
    if self.price <= (self.current_price - 1)
      errors.add(:base, "Your bid need to be higher or equal to the current bidding price!")
    end
  end

  def check_user
    if self.auction.user == self.user
      errors.add(:base, "You cannot bid on your own auction!")
    end
  end

end
