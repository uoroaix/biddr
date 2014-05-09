class AuctionsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_auction, only: [:edit, :destroy, :update, :show]

  def index
    @auctions = Auction.all.sort_by_desc - Auction.draft.sort_by_desc
  end

  def new
    @auction = Auction.new
  end

  def edit

  end

  def show
    @bid = Bid.new
    @bids = @auction.bids.all.sort_by_desc

  end

  def update
    if @auction.update_attributes(auction_attributes)
      redirect_to @auction, notice: "Sucessfully updated!"
    else
      render :edit
    end
  end

  def create
    auction = Auction.new(auction_attributes)
    auction.user = current_user
    if auction.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    if @auction.destroy
      redirect_to root_path
    else
      redirect_to rooth_path
    end
  end

  private

  def auction_attributes
    params.require(:auction).permit(:title, :details, :ends_on, :reserve_price)
  end

  def find_auction
    @auction = Auction.find(params[:id])
  end

end
