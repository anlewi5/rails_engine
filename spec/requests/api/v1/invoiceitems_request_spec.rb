require 'rails_helper'

describe "InvoiceItems API" do
  describe "Record Endpoints" do
    let(:customer)  {create(:customer)}
    let(:merchant)  {create(:merchant)}
    let(:item)      {create(:item)}
    let(:invoice)   {create(:invoice)}

    it "can list all invoice items" do
      create_list(:invoice_item, 3)

      get "/api/v1/invoice_items"

      invoice_items = JSON.parse(response.body)
      invoice_item = invoice_items.first

      expect(response).to be_success
      expect(invoice_items.count).to eq 3
      expect(invoice_item).to have_key("id")
      expect(invoice_item).to have_key("quantity")
      expect(invoice_item).to have_key("unit_price")
      expect(invoice_item).not_to have_key("created_at")
      expect(invoice_item).not_to have_key("updated_at")
      expect(invoice_item).to have_key("invoice_id")
      expect(invoice_item).to have_key("item_id")
    end

    it "can show single invoice item" do
      invoice_item = create(:invoice_item, invoice: invoice, item: item)

      get "/api/v1/invoice_items/#{invoice_item.id}"

      invoice_item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(invoice_item_response["id"]).to eq(invoice_item.id)
      expect(invoice_item_response["quantity"]).to eq(invoice_item.quantity)
      expect(invoice_item_response["unit_price"]).to eq(invoice_item.unit_price)
      expect(invoice_item_response["invoice_id"]).to eq(invoice.id)
      expect(invoice_item_response["item_id"]).to eq(item.id)
    end
  end
end
