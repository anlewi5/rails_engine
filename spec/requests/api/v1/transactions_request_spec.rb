require 'rails_helper'

describe "transactions API" do
  describe "record endpoints" do
    it "can list all transactions" do
      create_list(:transaction, 3)

      get "/api/v1/transactions"

      transactions = JSON.parse(response.body)
      transaction = transactions.first

      expect(response).to be_success

      expect(transactions.count).to eq(3)
      expect(transaction).to have_key("id")
      expect(transaction).to have_key("invoice_id")
      expect(transaction).to have_key("result")
      expect(transaction).to have_key("credit_card_number")
      
      expect(transaction).not_to have_key("credit_card_expiration_date")
      expect(transaction).not_to have_key("updated_at")
      expect(transaction).not_to have_key("created_at")
    end

    it "can get single transaction by id" do
      transaction = create(:transaction)

      get "/api/v1/transactions/#{transaction.id}"

      transaction_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(transaction_response["id"]).to eq(transaction.id)
      expect(transaction_response["invoice_id"]).to eq(transaction.invoice_id)
      expect(transaction_response["result"]).to eq(transaction.result)
    end

    it "can find a random transaction" do
      create_list(:transaction, 3)

      get "/api/v1/transactions/random"

      transaction_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(transaction_response).to have_key("id")
      expect(transaction_response).to have_key("invoice_id")
      expect(transaction_response).to have_key("result")
    end

    describe "queries" do
      describe "find?" do
        subject { get "/api/v1/transactions/find?#{params}" }
        let(:transaction_response) { JSON.parse(response.body) }

        before(:each) do
          @invoice_id = create(:invoice).id
          create(:transaction, id: 1,
                            invoice_id: @invoice_id,
                            credit_card_number: 12345,
                            credit_card_expiration_date: "2012-03",
                            result: "success",
                            created_at: "2012-03-06T16:54:31",
                            updated_at: "2013-03-06T16:54:31"
          )
        end

        shared_examples_for "a response that finds a single transaction" do
          it "finds the correct transaction" do
            subject
            expect(response).to be_success
            expect(transaction_response["id"]).to eq(1)
            expect(transaction_response["invoice_id"]).to eq(@invoice_id)
            expect(transaction_response["result"]).to eq("success")
          end
        end

        context "based on id" do
          let(:params) { "id=1" }
          it_behaves_like "a response that finds a single transaction"
        end

        context "based on invoice_id" do
          let(:params) { "invoice_id=#{@invoice_id}" }
          it_behaves_like "a response that finds a single transaction"
        end

        context "based on credit_card_number" do
          let(:params) { "credit_card_number=12345" }
          it_behaves_like "a response that finds a single transaction"
        end

        context "based on credit_card_expiration_date" do
          let(:params) { "credit_card_expiration_date=2012-03" }
          it_behaves_like "a response that finds a single transaction"
        end

        context "based on result" do
          let(:params) { "result=success" }
          it_behaves_like "a response that finds a single transaction"
        end

        context "based on created_at" do
          let(:params) { "created_at=2012-03-06T16:54:31" }
          it_behaves_like "a response that finds a single transaction"
        end

        context "based on updated_at" do
          let(:params) { "updated_at=2013-03-06T16:54:31" }
          it_behaves_like "a response that finds a single transaction"
        end
      end

      describe "find_all?" do
        subject { get "/api/v1/transactions/find_all?#{params}" }
        let(:transaction_response) { JSON.parse(response.body) }

        before do
          @invoice_id_1 = create(:invoice).id
          @invoice_id_2 = create(:invoice).id
          create :transaction, id: 1,
                              invoice_id: @invoice_id_1,
                              credit_card_number: 54321,
                              credit_card_expiration_date: "2013-03",
                              result: "success",
                              created_at: "2013-03-06T16:54:31",
                              updated_at: "2014-03-06T16:54:31"
          create :transaction, id: 2,
                              invoice_id: @invoice_id_2,
                              credit_card_number: 12345,
                              credit_card_expiration_date: "2012-03",
                              result: "failed",
                              created_at: "2012-03-06T16:54:31",
                              updated_at: "2013-03-06T16:54:31"
          create :transaction, id: 3,
                              invoice_id: @invoice_id_2,
                              credit_card_number: 12345,
                              credit_card_expiration_date: "2012-03",
                              result: "failed",
                              created_at: "2012-03-06T16:54:31",
                              updated_at: "2013-03-06T16:54:31"
        end

        shared_examples_for 'a response that finds transactions' do |*transaction_ids|
          it "finds the correct transactions" do
            subject
            expect(response).to be_success
            expect(transaction_response).to be_an Array
            expect(transaction_response.map { |result| result['id'] }).to contain_exactly(*transaction_ids)
          end
        end

        context 'based on id' do
          let(:params) { "id=2" }
          it_behaves_like 'a response that finds transactions', 2
        end

        context "based on invoice_id" do
          let(:params) { "invoice_id=#{@invoice_id_2}" }
          it_behaves_like 'a response that finds transactions', 2, 3
        end

        context "based on credit_card_number" do
          let(:params) { "credit_card_number=12345" }
          it_behaves_like 'a response that finds transactions', 2, 3
        end

        context "based on credit_card_expiration_date" do
          let(:params) { "credit_card_expiration_date=2012-03" }
          it_behaves_like 'a response that finds transactions', 2, 3
        end

        context "based on result" do
          let(:params) { "result=failed" }
          it_behaves_like 'a response that finds transactions', 2, 3
        end

        context "based on created_at" do
          let(:params) { "created_at=2012-03-06T16:54:31" }
          it_behaves_like 'a response that finds transactions', 2, 3
        end

        context "based on updated_at" do
          let(:params) { "updated_at=2013-03-06T16:54:31" }
          it_behaves_like 'a response that finds transactions', 2, 3
        end
      end
    end
  end
  describe "relationship endpoints" do
    subject { get "/api/v1/transactions/#{transaction.id}/#{relation}" }
    let(:transaction_response) { JSON.parse(response.body) }

    let!(:customer)     { create(:customer) }
    let!(:merchant)     { create(:merchant) }
    let!(:invoice)      { create(:invoice, merchant: merchant, customer: customer) }
    let!(:item)         { create(:item, merchant: merchant) }
    let!(:invoice_item) { create(:invoice_item, invoice: invoice, item: item) }
    let!(:transaction)  { create(:transaction, invoice: invoice) }

    shared_examples_for 'a response that finds x for a merchant' do
      let(:transaction_id) { transaction.id }

      it "finds the correct x" do
        subject
        expect(response).to be_success
        expect(transaction_response.first).to have_key "id"
        expect(transaction_response.first).to have_key "status"
      end
    end

    context "where x is invoice" do
      let(:relation) { "invoice" }
      it_behaves_like 'a response that finds x for a merchant'
    end
  end
end
