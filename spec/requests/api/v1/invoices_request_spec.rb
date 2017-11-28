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

    expect(response).to be_success
    expect(invoice_response.count).to eq(1)
  end

  it "can find_all invoice by status" do
    get "/api/v1/invoices/find_all?status=shipped"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_response.count).to eq(2)
  end

  it "can find_all invoice by customer_id" do
    get "/api/v1/invoices/find_all?customer_id=#{@customer.id}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_response.count).to eq(2)
  end

  it "can find_all invoice by merchant_id" do
    get "/api/v1/invoices/find_all?merchant_id=#{@merchant.id}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_response.count).to eq(2)
  end

  it "can find_all invoice by created_at" do
    get "/api/v1/invoices/find_all?created_at=#{@invoice.created_at}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_response.count).to eq(2)
  end

  it "can find_all invoice by updated_at" do
    get "/api/v1/invoices/find_all?updated_at=#{@invoice.updated_at}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_response.count).to eq(2)
  end

  it "can find a random invoice" do
    get "/api/v1/invoices/random"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_response).to_not be_empty
  end
end
