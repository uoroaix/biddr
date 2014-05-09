class BidsController < ApplicationController

  def create
    @auction = Auction.find(params[:auction_id])
    @bid = @auction.bids.new(bid_attributes)
    @bid.user = current_user
    if @bid.save
      @auction.update_attributes(current_price: (@bid.price + 1))
      if @bid.price >= @bid.reserve_price
        @auction.meet_reserve
      elsif @auction.state == "published"
        @auction.bid
      end
      redirect_to auction_path(@auction), notice: "Thank you for bidding!"
    else
      redirect_to auction_path(@auction), alert: "#{@bid.errors.full_messages.join(", ")}"
    end
  end

  def index
    @bids = current_user.bids
  end

  private

  def bid_attributes
    params.require(:bid).permit(:price)
  end

end
