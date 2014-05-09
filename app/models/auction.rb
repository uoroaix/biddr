class Auction < ActiveRecord::Base

  has_many :bids, dependent: :destroy
  belongs_to :user

  validates :title, presence: :true
  
  scope :sort_by_desc, -> {order("created_at DESC")}
  scope :draft, -> { where(state: :draft) }

  state_machine :state, initial: :draft do

    event :publish do
      transition draft: :published
    end

    event :bid do
      transition published: :reserve_not_met
    end

    event :meet_reserve do
      transition [:published, :reserve_not_met] => :reserve_met
    end 

    event :cancel do
      transition [:draft, :published, :reserve_not_met] => :canceled
    end

    event :won_bid do
      transition [:published, :reserve_not_met] => :won
    end

  end

end
