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
                            unit_price: 500)
      invoice_item2 = create(:invoice_item, invoice_id: invoice2.id, quantity: 3,
                            unit_price: 400)
      transaction1 = create(:transaction, invoice_id: invoice1.id)
      transaction2 = create(:transaction, invoice_id: invoice2.id)

      get "/api/v1/merchants/#{merchant.id}/revenue"

      merchant_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(merchant_response["revenue"]).to eq "22.0"
    end

    it "returns the revenue for a merchant on specific invoice date" do
      merchant = create(:merchant)
      invoice1 = create(:invoice, merchant_id: merchant.id, created_at: "2012-03-16 11:55:05")
      invoice2 = create(:invoice, merchant_id: merchant.id, created_at: "2013-03-16 11:55:05")
      invoice_item1 = create(:invoice_item, invoice_id: invoice1.id, quantity: 2,
                            unit_price: 500)
      invoice_item2 = create(:invoice_item, invoice_id: invoice2.id, quantity: 3,
                            unit_price: 400)
      transaction1 = create(:transaction, invoice_id: invoice1.id)
      transaction2 = create(:transaction, invoice_id: invoice2.id)

      get "/api/v1/merchants/#{merchant.id}/revenue?date=2012-03-16 11:55:05"

      merchant_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(merchant_response["revenue"]).to eq "10.0"
    end

    it 'returns favorite customer for merchant' do
      merchant      = create(:merchant)
      customer      = create(:customer)
      customer2     = create(:customer)
      invoice       = create(:invoice, merchant: merchant, customer: customer)
      invoice2      = create(:invoice, merchant: merchant, customer: customer)
      invoice3      = create(:invoice, merchant: merchant, customer: customer2)
      transactions  = create(:transaction, invoice:invoice)
      transactions2 = create(:transaction, invoice:invoice)
      transactions3 = create(:transaction, invoice:invoice2)
      transactions4 = create(:transaction, invoice:invoice3)

      get "/api/v1/merchants/#{merchant.id}/favorite_customer"

      favorite_customer_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(favorite_customer_response["first_name"]).to eq(customer.first_name)
      expect(favorite_customer_response["last_name"]).to eq(customer.last_name)
    end

    it 'returns top merchants when quantity 1 for merchant' do
      merchant      = create(:merchant)
      merchant2     = create(:merchant)
      invoice       = create(:invoice, merchant: merchant)
      invoice2      = create(:invoice, merchant: merchant2)
      invoice_item  = create(:invoice_item,
                              invoice: invoice,
                              quantity: 2,
                              unit_price: 400)
      invoice_item2 = create(:invoice_item,
                              invoice: invoice,
                              quantity: 2,
                              unit_price: 400)
      invoice_item3 = create(:invoice_item,
                              invoice: invoice2,
                              quantity: 1,
                              unit_price: 600)
      transactions  = create(:transaction, invoice:invoice)
      transactions2 = create(:transaction, invoice:invoice)
      transactions3 = create(:transaction, invoice:invoice2)
      transactions4 = create(:transaction, invoice:invoice2)

      get "/api/v1/merchants/most_revenue?quantity=1"

      top_merchants_response = JSON.parse(response.body)
      top_merchant = top_merchants_response.first

      expect(response).to be_success
      expect(top_merchants_response.count).to eq(1)
      expect(top_merchant["id"]).to eq(merchant.id)
      expect(top_merchant["name"]).to eq(merchant.name)
    end

    it 'returns top merchants when quantity 2 for merchant' do
      merchant      = create(:merchant)
      merchant2     = create(:merchant)
      invoice       = create(:invoice, merchant: merchant)
      invoice2      = create(:invoice, merchant: merchant2)
      invoice_item  = create(:invoice_item,
                              invoice: invoice,
                              quantity: 2,
                              unit_price: 400)
      invoice_item2 = create(:invoice_item,
                              invoice: invoice,
                              quantity: 2,
                              unit_price: 400)
      invoice_item3 = create(:invoice_item,
                              invoice: invoice2,
                              quantity: 1,
                              unit_price: 600)
      transactions  = create(:transaction, invoice:invoice)
      transactions2 = create(:transaction, invoice:invoice)
      transactions3 = create(:transaction, invoice:invoice2)
      transactions4 = create(:transaction, invoice:invoice2)

      get "/api/v1/merchants/most_revenue?quantity=2"

      top_merchants_response = JSON.parse(response.body)
      top_merchant = top_merchants_response.first

      expect(response).to be_success
      expect(top_merchants_response.count).to eq(2)
      expect(top_merchant["id"]).to eq(merchant.id)
      expect(top_merchant["name"]).to eq(merchant.name)
    end

    it 'returns total revenue for invoice date' do
      merchant      = create(:merchant)
      merchant2     = create(:merchant)
      invoice       = create(:invoice, merchant: merchant, created_at: "2012-03-07 10:54:55")
      invoice2      = create(:invoice, merchant: merchant2, created_at: "2012-03-07 10:54:55")
      invoice_item  = create(:invoice_item,
                              invoice: invoice,
                              quantity: 2,
                              unit_price: 400)
      invoice_item2 = create(:invoice_item,
                              invoice: invoice,
                              quantity: 2,
                              unit_price: 400)
      invoice_item3 = create(:invoice_item,
                              invoice: invoice2,
                              quantity: 1,
                              unit_price: 600)
      transactions  = create(:transaction, invoice:invoice)
      transactions  = create(:transaction, invoice:invoice2)

      get "/api/v1/merchants/revenue?date=2012-03-07 10:54:55"

      revenue_by_date_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(revenue_by_date_response["total_revenue"]).to eq("22.0")
    end

    it "returns the top x merchants ranked by total number of items sold" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      invoice1 = create(:invoice, merchant_id: merchant1.id)
      invoice2 = create(:invoice, merchant_id: merchant2.id)
      invoice_item1 = create(:invoice_item, invoice_id: invoice1.id)
      invoice_item2 = create(:invoice_item, invoice_id: invoice2.id)
      transaction1 = create(:transaction, invoice_id: invoice1.id)
      transaction2 = create(:transaction, invoice_id: invoice2.id)

      get "/api/v1/merchants/most_items?quantity=2"

      merchant_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(merchant_response).to be_an Array
      expect(merchant_response.count).to eq 2
      expect(merchant_response.first).to have_key "id"
      expect(merchant_response.first).to have_key "name"
    end

    it "returns the pending_customers" do
      customer      = create(:customer)
      customer2     = create(:customer)
      merchant1     = create(:merchant)
      merchant2     = create(:merchant)
      invoice1      = create(:invoice,
                              merchant_id: merchant1.id,
                              customer: customer)
      invoice2      = create(:invoice,
                              merchant_id: merchant2.id,
                              customer: customer2)
      invoice_item1 = create(:invoice_item, invoice_id: invoice1.id)
      invoice_item2 = create(:invoice_item, invoice_id: invoice2.id)
      transaction1  = create(:transaction,
                            invoice_id: invoice1.id,
                            result: "failed")
      transaction2  = create(:transaction,
                            invoice_id: invoice2.id)

      get "/api/v1/merchants/#{merchant1.id}/customers_with_pending_invoices"

      pending_customers_response = JSON.parse(response.body)
      pending_customer = pending_customers_response.first

      expect(response).to be_success
      expect(pending_customers_response).to be_an Array
      expect(pending_customers_response.count).to eq 1
      expect(pending_customers_response.first).to have_key "id"
      expect(pending_customers_response.first).to have_key "first_name"
      expect(pending_customer["id"]).to eq(customer.id)
      expect(pending_customer["first_name"]).to eq(customer.first_name)
    end
  end
end
