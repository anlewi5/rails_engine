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
    expect(invoice).to have_key("created_at")
    expect(invoice).to have_key("updated_at")
    expect(invoice).to have_key("customer_id")
    expect(invoice).to have_key("merchant_id")
  end
end
