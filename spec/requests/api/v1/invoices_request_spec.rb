require 'rails_helper'

describe "Invoice API" do
  it "can list all invoices" do
    customer = create(:customer)
    merchant = create(:merchant)
    create_list(:invoice, 3, customer_id: customer.id, merchant_id: merchant.id)

    get "/api/v1/invoices"

    invoices = JSON.parse(response.body)
    invoice = invoices.first

    expect(response).to be_success
    expect(invoices.count).to eq 3
    expect(invoice).to have_key("id")
    expect(invoice).to have_key("status")
    expect(invoice).to have_key("status")
    expect(invoice).not_to have_key("created_at")
    expect(invoice).not_to have_key("updated_at")
    expect(invoice).to have_key("customer_id")
    expect(invoice).to have_key("merchant_id")
  end

  it "can show single invoice" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)

    get "/api/v1/invoices/#{invoice.id}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_response["id"]).to eq(invoice.id)
    expect(invoice_response["status"]).to eq(invoice.status)
    expect(invoice_response["customer_id"]).to eq(customer.id)
    expect(invoice_response["merchant_id"]).to eq(merchant.id)
  end
end

describe "Invoice find, find all, and random" do
  before(:each) do
    @customer = create(:customer)
    @merchant = create(:merchant)
    @invoice = Invoice.create!(customer: @customer, merchant: @merchant,
                              status: "shipped", created_at: "2012-03-06T16:54:31",
                              updated_at: "2012-03-06T16:54:31")
    @invoice2 = Invoice.create!(customer: @customer, merchant: @merchant,
                              status: "shipped", created_at: "2012-03-06T16:54:31",
                              updated_at: "2012-03-06T16:54:31")
  end

  it "can find single invoice by id" do
    get "/api/v1/invoices/find?id=#{@invoice.id}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_response["id"]).to eq(@invoice.id)
  end

  it "can find single invoice by status" do
    get "/api/v1/invoices/find?status=shipped"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_response["status"]).to eq("shipped")
  end

  it "can find single invoice by customer_id" do
    get "/api/v1/invoices/find?customer_id=#{@customer.id}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_response["customer_id"]).to eq(@customer.id)
  end

  it "can find single invoice by merchant_id" do
    get "/api/v1/invoices/find?merchant_id=#{@merchant.id}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_response["merchant_id"]).to eq(@merchant.id)
  end

  it "can find single invoice by created_at" do
    get "/api/v1/invoices/find?created_at=#{@invoice.created_at}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_response["id"]).to eq(@invoice.id)
  end

  it "can find single invoice by updated_at" do
    get "/api/v1/invoices/find?updated_at=#{@invoice.updated_at}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_response["id"]).to eq(@invoice.id)
  end

  it "can find_all invoice by id" do
    get "/api/v1/invoices/find_all?id=#{@invoice2.id}"

    invoice_response = JSON.parse(response.body)
    invoice = invoice_response.first

    expect(response).to be_success
    expect(invoice["id"]).to eq (2)
    expect(invoice["status"]).to eq("shipped")
    expect(invoice["customer_id"]).to eq(@customer.id)
    expect(invoice["merchant_id"]).to eq(@merchant.id)
  end

  it "can find_all invoice by status" do
    get "/api/v1/invoices/find_all?status=shipped"

    invoice_response = JSON.parse(response.body)
    invoice = invoice_response.first

    expect(response).to be_success
    expect(invoice_response.count).to eq(2)
    expect(invoice["id"]).to eq (1)
    expect(invoice["status"]).to eq("shipped")
    expect(invoice["customer_id"]).to eq(@customer.id)
    expect(invoice["merchant_id"]).to eq(@merchant.id)
  end

  it "can find_all invoice by customer_id" do
    get "/api/v1/invoices/find_all?customer_id=#{@customer.id}"

    invoice_response = JSON.parse(response.body)
    invoice = invoice_response.first

    expect(response).to be_success
    expect(invoice_response.count).to eq(2)
    expect(invoice["id"]).to eq (1)
    expect(invoice["status"]).to eq("shipped")
    expect(invoice["customer_id"]).to eq(@customer.id)
    expect(invoice["merchant_id"]).to eq(@merchant.id)
  end

  it "can find_all invoice by merchant_id" do
    get "/api/v1/invoices/find_all?merchant_id=#{@merchant.id}"

    invoice_response = JSON.parse(response.body)
    invoice = invoice_response.first

    expect(response).to be_success
    expect(invoice_response.count).to eq(2)
    expect(invoice["id"]).to eq (1)
    expect(invoice["status"]).to eq("shipped")
    expect(invoice["customer_id"]).to eq(@customer.id)
    expect(invoice["merchant_id"]).to eq(@merchant.id)
  end

  it "can find_all invoice by created_at" do
    get "/api/v1/invoices/find_all?created_at=#{@invoice.created_at}"

    invoice_response = JSON.parse(response.body)
    invoice = invoice_response.first

    expect(response).to be_success
    expect(invoice_response.count).to eq(2)
    expect(invoice["id"]).to eq (1)
    expect(invoice["status"]).to eq("shipped")
    expect(invoice["customer_id"]).to eq(@customer.id)
    expect(invoice["merchant_id"]).to eq(@merchant.id)
  end

  it "can find_all invoice by updated_at" do
    get "/api/v1/invoices/find_all?updated_at=#{@invoice.updated_at}"

    invoice_response = JSON.parse(response.body)
    invoice = invoice_response.first

    expect(response).to be_success
    expect(invoice_response.count).to eq(2)
    expect(invoice["id"]).to eq (1)
    expect(invoice["status"]).to eq("shipped")
    expect(invoice["customer_id"]).to eq(@customer.id)
    expect(invoice["merchant_id"]).to eq(@merchant.id)
  end

  it "can find a random invoice" do
    get "/api/v1/invoices/random"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_response).to have_key("id")
    expect(invoice_response).to have_key("status")
    expect(invoice_response).to have_key("customer_id")
    expect(invoice_response).to have_key("merchant_id")
  end

  describe "relationship endpoints" do
    subject { get "/api/v1/invoices/#{invoice_id}/#{relation}" }
    let(:invoice_response) { JSON.parse(response.body) }

    let(:customer)     { create(:customer) }
    let(:merchant)     { create(:merchant) }
    let(:invoice)      { create(:invoice, merchant: merchant, customer: customer) }
    let(:item)         { create(:item) }
    let(:invoice_item) { create(:invoice_item, invoice: invoice, item: item) }
    let(:transaction)  { create(:transaction, invoice: invoice) }

    shared_examples_for 'a response that finds x for an invoice' do
      let(:invoice_id) { invoice.id }

      it "finds the correct x" do
        subject
        expect(response).to be_success
        expect(invoice_response).to have_key "id"
      end
    end

    shared_examples_for 'a response that finds x-es for an invoice' do
      let(:invoice_id) { invoice.id }

      it "finds the correct x-es" do
        subject
        expect(response).to be_success
        expect(invoice_response).to be_an Array
      end
    end

    context "where x is merchant" do
      let(:relation) { "merchant" }
      it_behaves_like 'a response that finds x for an invoice'
    end

    context "where x is customer" do
      let(:relation) { "customer" }
      it_behaves_like 'a response that finds x for an invoice'
    end

    context "where x is transactions" do
      let(:relation) { "transactions" }
      it_behaves_like 'a response that finds x-es for an invoice'
    end

    context "where x is items" do
      let(:relation) { "items" }
      it_behaves_like 'a response that finds x-es for an invoice'
    end

    context "where x is invoice_items" do
      let(:relation) { "invoice_items" }
      it_behaves_like 'a response that finds x-es for an invoice'
    end
  end
end
