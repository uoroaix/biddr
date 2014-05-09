require 'spec_helper'

describe BidsController do
  let(:user) { create(:user) }
  before { sign_in user }

  describe "#create" do
    let(:auction) { create(:auction) }
    let(:bid) { create(:bid, auction: auction) }

    context "with valid request" do

      def valid_request
        post :create, auction_id: auction.id, bid: {price: 9999}
      end

      it "should save the bid into the database" do
        expect { valid_request }.to change { Bid.count }.by(1)
      end

      it "associates the bid with the auction whose id is passed" do
        expect { valid_request }.to change { auction.bids.count }.by(1)
      end

      it "current_price should be set to the lastest bid price + 1" do
        valid_request
        auction.reload
        expect( auction.current_price ).to eq(10000)
      end

    end

    context "with invalid request" do

      def invalid_request
        post :create, auction_id: auction.id, bid: {price: 10}
      end

      it "should not save when the bid price is lower than the current price" do
        auction
        expect { invalid_request }.to change { auction.bids.count }.by(0)
      end

      it "should render the page with flash alert" do
        invalid_request
        expect(flash[:alert]).to be
      end

    end

  end

end
