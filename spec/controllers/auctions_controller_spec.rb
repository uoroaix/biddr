require 'spec_helper'

describe AuctionsController do
  let(:user) { create(:user) }
  before { sign_in user }

  let(:auction) { create(:auction) }
  let(:bid) { create(:bid, auction: auction)}

  describe "#index" do 

    it "should show all published or above auctions in the database" do 
      auction.state = "published"
      auction.save
      get :index
      expect(assigns(:auctions)).to include(auction)
    end

    it "should not show draft auctions" do
      auction.state = "draft"
      auction.save
      get :index
      expect(assigns(:auctions)).to_not include(auction)
    end

  end


  describe "#new" do

    it "should assigns a new auction" do
      get :new
      expect(assigns(:auction)).to be_a_new(Auction)
    end

  end


  describe "#create" do

    context "with valid request" do 

      def valid_request
        post :create, auction: {title: "valid title", details: "valid description",
                                ends_on: Time.now, reserve_price: 1000}
      end

      it "should save an auction in the database" do
        expect { valid_request }.to change { Auction.count }.by(1)
      end

      it "should redirect to root path after success create" do
        valid_request
        expect(response).to redirect_to(root_path)
      end

    end

    context "with invalid request" do

      def invalid_request
        post :create, auction: {title: "", details: "valid description",
                                ends_on: Time.now, reserve_price: 1000}
      end

      it "should not save an auction in the database" do
        expect { invalid_request }.to change { Auction.count }.by(0)
      end

      it "should render the new page" do
        invalid_request
        expect(response).to render_template(:new)
      end

    end
  end


  describe "#destroy" do 

    def delete_request
      delete :destroy, id: auction.id
    end

    it "should delete the auction from the database" do 
      auction
      expect { delete_request }.to change { Auction.count }.by(-1)
    end

    it "should redirect_to the root_path after successfull delete request" do
      delete_request
      expect(response).to redirect_to(root_path)
    end

  end


  describe "#edit" do

    it "assigns the auction with the current passed id" do
      get :edit, id: auction.id
      expect(assigns(:auction)).to eq(auction)
    end

    it "renders the edit template" do
      get :edit, id: auction.id
      expect(response).to render_template(:edit)
    end

  end


  describe "#update" do 

    def update_request
      patch :update, id: auction.id, auction: {title: "some new title"}
    end

    it "update the auction with new title" do
      update_request
      auction.reload
      expect(auction.title).to match /some new title/i
    end

    it "redirects to auction show page after successful update" do
      update_request
      expect(response).to redirect_to(auction)
    end

    it "renders edit template with failed update" do
      patch :update, id: auction.id, auction: {title: ""}
      expect(response).to render_template(:edit)
    end

    it "sets flash message with successful update" do
      update_request
      expect(flash[:notice]).to be
    end

  end

  describe "#show" do

    it "assigns the auction with the passed id" do
      get :show, id: auction.id
      expect(assigns(:auction)).to eq(auction)
    end

    it "renders the show template" do
      get :show, id: auction.id
      expect(response).to render_template(:show)
    end

    it "assigns a new bid" do
      get :show, id: auction.id
      expect(assigns(:bid)).to be_a_new(Bid)
    end

    it "assigns all bids of that auction" do
      auction
      bid
      get :show, id: auction.id
      expect(assigns(:bids)).to include(bid)      
    end

  end

end
