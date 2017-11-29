require 'rails_helper'

describe "Merchants API" do
  it "can list all merchants" do
    create_list(:merchant, 3)

    get "/api/v1/merchants"

    merchants = JSON.parse(response.body)
    merchant = merchants.first

    expect(response).to be_success
    expect(merchants.count).to eq(3)
    expect(merchant).to have_key("id")
    expect(merchant).to have_key("name")
    expect(merchant).to have_key("updated_at")
    expect(merchant).to have_key("created_at")
  end

  it "can get single merchant by id" do
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}"

    merchant_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(merchant_response["id"]).to eq(merchant.id)
    expect(merchant_response["name"]).to eq(merchant.name)
  end

  describe "queries" do
    describe "find?" do
      before(:each) do
        @merchant = create(:merchant,
                           name: "MerchantName",
                           created_at: "2012-03-06T16:54:31",
                           updated_at: "2013-03-06T16:54:31"
                          )
      end

      it "can find a single merchant based on id" do
        get "/api/v1/merchants/find?id=#{@merchant.id}"

        merchant_response = JSON.parse(response.body)

        expect(response).to be_success
        expect(merchant_response["id"]).to eq(@merchant.id)
        expect(merchant_response["name"]).to eq(@merchant.name)
      end

      it "can find a single merchant based on name" do
        get "/api/v1/merchants/find?name=#{@merchant.name}"

        merchant_response = JSON.parse(response.body)

        expect(response).to be_success
        expect(merchant_response["id"]).to eq(@merchant.id)
        expect(merchant_response["name"]).to eq(@merchant.name)
      end

      it "can find a single merchant based on created_at" do
        get "/api/v1/merchants/find?created_at=#{@merchant.created_at}"

        merchant_response = JSON.parse(response.body)

        expect(response).to be_success
        expect(merchant_response["id"]).to eq(@merchant.id)
        expect(merchant_response["name"]).to eq(@merchant.name)
      end

      it "can find a single merchant based on updated_at" do
        get "/api/v1/merchants/find?updated_at=#{@merchant.updated_at}"

        merchant_response = JSON.parse(response.body)

        expect(response).to be_success
        expect(merchant_response["id"]).to eq(@merchant.id)
        expect(merchant_response["name"]).to eq(@merchant.name)
      end
    end

    describe "find_all?" do
      subject { get "/api/v1/merchants/find_all?#{params}" }
      let(:merchant_response) { JSON.parse(response.body) }

      before do
        create :merchant, id: 1,
                          name: "DifferentMerchant",
                          created_at: "2014-03-06T16:54:31",
                          updated_at: "2015-03-06T16:54:31"
        create :merchant, id: 2,
                          name: "SameMerchant",
                          created_at: "2013-03-06T16:54:31",
                          updated_at: "2014-03-06T16:54:31"
        create :merchant, id: 3,
                          name: "SameMerchant",
                          created_at: "2013-03-06T16:54:31",
                          updated_at: "2014-03-06T16:54:31"
      end

      shared_examples_for 'a response that finds merchants' do |*merchant_ids|
        it "finds the correct merchants" do
          subject
          expect(response).to be_success
          expect(merchant_response).to be_an Array
          expect(merchant_response.map { |result| result['id'] }).to contain_exactly(*merchant_ids)
        end
      end

      context 'based on id' do
        let(:params) { "id=2" }
        it_behaves_like 'a response that finds merchants', 2
      end

      context "based on name" do
        let(:params) { "name=SameMerchant" }
        it_behaves_like 'a response that finds merchants', 2, 3
      end

      context "based on created_at" do
        let(:params) { "created_at=2013-03-06T16:54:31" }
        it_behaves_like 'a response that finds merchants', 2, 3
      end

      context "based on updated_at" do
        let(:params) { "updated_at=2014-03-06T16:54:31" }
        it_behaves_like 'a response that finds merchants', 2, 3
      end
    end
  end
end
