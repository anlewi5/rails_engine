require 'rails_helper'

describe "Merchants API" do
  describe "record endpoints" do
    it "can list all merchants" do
      create_list(:merchant, 3)

      get "/api/v1/merchants"

      merchants = JSON.parse(response.body)
      merchant = merchants.first

      expect(response).to be_success
      expect(merchants.count).to eq(3)
      expect(merchant).to have_key("id")
      expect(merchant).to have_key("name")
      expect(merchant).not_to have_key("updated_at")
      expect(merchant).not_to have_key("created_at")
    end

    it "can get single merchant by id" do
      merchant = create(:merchant)

      get "/api/v1/merchants/#{merchant.id}"

      merchant_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(merchant_response["id"]).to eq(merchant.id)
      expect(merchant_response["name"]).to eq(merchant.name)
    end

    it "can find a random merchant" do
      create_list(:merchant, 3)

      get "/api/v1/merchants/random"

      merchant_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(merchant_response).to have_key("id")
      expect(merchant_response).to have_key("name")
    end

    describe "queries" do
      describe "find?" do
        subject { get "/api/v1/merchants/find?#{params}" }
        let(:merchant_response) { JSON.parse(response.body) }

        before(:each) do
          create(:merchant, id: 1,
                            name: "MerchantName",
                            created_at: "2012-03-06T16:54:31",
                            updated_at: "2013-03-06T16:54:31"
          )
        end

        shared_examples_for "a response that finds a single merchant" do
          it "finds the correct merchant" do
            subject
            expect(response).to be_success
            expect(merchant_response["id"]).to eq(1)
            expect(merchant_response["name"]).to eq("MerchantName")
          end
        end

        context "based on id" do
          let(:params) { "id=1" }
          it_behaves_like "a response that finds a single merchant"
        end

        context "based on name" do
          let(:params) { "name=MerchantName" }
          it_behaves_like "a response that finds a single merchant"
        end

        context "based on created_at" do
          let(:params) { "created_at=2012-03-06T16:54:31" }
          it_behaves_like "a response that finds a single merchant"
        end

        context "based on updated_at" do
          let(:params) { "updated_at=2013-03-06T16:54:31" }
          it_behaves_like "a response that finds a single merchant"
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
  describe "business intelligence" do
    it "returns the total revenue for single merchant" do
      merchant = create(:merchant)
      invoice1 = create(:invoice, merchant_id: merchant.id)
      invoice2 = create(:invoice, merchant_id: merchant.id)
      invoice_item1 = create(:invoice_item, invoice_id: invoice1.id, quantity: 2,
                            price: 5)
      invoice_item2 = create(:invoice_item, invoice_id: invoice2.id, quantity: 3,
                            price: 4)

      get "/api/v1/merchants/#{merchant.id}/revenue"

      merchant_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(merchant.response["total_revenue"]).to eq 22
    end
  end
end
