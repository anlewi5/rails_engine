require 'rails_helper'

describe "customers API" do
  describe "record endpoints" do
    it "can list all customers" do
      create_list(:customer, 3)

      get "/api/v1/customers"

      customers = JSON.parse(response.body)
      customer = customers.first

      expect(response).to be_success
      expect(customers.count).to eq(3)
      expect(customer).to have_key("id")
      expect(customer).to have_key("first_name")
      expect(customer).to have_key("last_name")
      expect(customer).not_to have_key("updated_at")
      expect(customer).not_to have_key("created_at")
    end

    it "can get single customer by id" do
      customer = create(:customer)

      get "/api/v1/customers/#{customer.id}"

      customer_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(customer_response["id"]).to eq(customer.id)
      expect(customer_response["first_name"]).to eq(customer.first_name)
      expect(customer_response["last_name"]).to eq(customer.last_name)
    end

    it "can find a random customer" do
      create_list(:customer, 3)

      get "/api/v1/customers/random"

      customer_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(customer_response).to have_key("id")
      expect(customer_response).to have_key("first_name")
      expect(customer_response).to have_key("last_name")
    end

    describe "queries" do
      describe "find?" do
        subject { get "/api/v1/customers/find?#{params}" }
        let(:customer_response) { JSON.parse(response.body) }

        before(:each) do
          create(:customer, id: 1,
                            first_name: "customerFirst",
                            last_name:  "customerLast",
                            created_at: "2012-03-06T16:54:31",
                            updated_at: "2013-03-06T16:54:31"
          )
        end

        shared_examples_for "a response that finds a single customer" do
          it "finds the correct customer" do
            subject
            expect(response).to be_success
            expect(customer_response["id"]).to eq(1)
            expect(customer_response["first_name"]).to eq("customerFirst")
            expect(customer_response["last_name"]).to eq("customerLast")
          end
        end

        context "based on id" do
          let(:params) { "id=1" }
          it_behaves_like "a response that finds a single customer"
        end

        context "based on first name" do
          let(:params) { "first_name=customerFirst" }
          it_behaves_like "a response that finds a single customer"
        end

        context "based on last name" do
          let(:params) { "last_name=customerLast" }
          it_behaves_like "a response that finds a single customer"
        end

        context "based on created_at" do
          let(:params) { "created_at=2012-03-06T16:54:31" }
          it_behaves_like "a response that finds a single customer"
        end

        context "based on updated_at" do
          let(:params) { "updated_at=2013-03-06T16:54:31" }
          it_behaves_like "a response that finds a single customer"
        end
      end

      describe "find_all?" do
        subject { get "/api/v1/customers/find_all?#{params}" }
        let(:customer_response) { JSON.parse(response.body) }

        before do
          create :customer, id: 1,
                            first_name: "DifferentCustomerFirst",
                            last_name:  "DifferentCustomerLast",
                            created_at: "2014-03-06T16:54:31",
                            updated_at: "2015-03-06T16:54:31"
          create :customer, id: 2,
                            first_name: "SameCustomerFirst",
                            last_name:  "SameCustomerLast",
                            created_at: "2013-03-06T16:54:31",
                            updated_at: "2014-03-06T16:54:31"
          create :customer, id: 3,
                            first_name: "SameCustomerFirst",
                            last_name:  "SameCustomerLast",
                            created_at: "2013-03-06T16:54:31",
                            updated_at: "2014-03-06T16:54:31"
        end

        shared_examples_for 'a response that finds customers' do |*customer_ids|
          it "finds the correct customers" do
            subject
            expect(response).to be_success
            expect(customer_response).to be_an Array
            expect(customer_response.map { |result| result['id'] }).to contain_exactly(*customer_ids)
          end
        end

        context 'based on id' do
          let(:params) { "id=2" }
          it_behaves_like 'a response that finds customers', 2
        end

        context "based on first name" do
          let(:params) { "first_name=SameCustomerFirst" }
          it_behaves_like 'a response that finds customers', 2, 3
        end

        context "based on last name" do
          let(:params) { "last_name=SameCustomerLast" }
          it_behaves_like 'a response that finds customers', 2, 3
        end

        context "based on created_at" do
          let(:params) { "created_at=2013-03-06T16:54:31" }
          it_behaves_like 'a response that finds customers', 2, 3
        end

        context "based on updated_at" do
          let(:params) { "updated_at=2014-03-06T16:54:31" }
          it_behaves_like 'a response that finds customers', 2, 3
        end
      end
    end
  end
end
