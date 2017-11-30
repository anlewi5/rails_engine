require 'rails_helper'

describe "InvoiceItem API" do
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

  describe "Invoice item find, find all, and random" do
    before(:each) do
      customer       = create(:customer)
      merchant       = create(:merchant)
      @invoice       = create(:invoice, customer: customer, merchant: merchant)
      @item          = create(:item, merchant: merchant)
      @invoice_item  = create(:invoice_item,
                              item: @item,
                              invoice: @invoice,
                              quantity: 4,
                              unit_price: 300,
                              created_at: "2017-11-30 16:19:41 UTC",
                              updated_at: "2017-11-30 16:19:41 UTC")
      @invoice_item2 = create(:invoice_item,
                              item: @item,
                              invoice: @invoice,
                              quantity: 2,
                              unit_price: 800,
                              created_at: "2017-11-30 16:19:41 UTC",
                              updated_at: "2017-11-30 16:19:41 UTC")
      @invoice_item3 = create(:invoice_item,
                              item: @item,
                              invoice: @invoice,
                              quantity: 4,
                              unit_price: 300,
                              created_at: "2017-11-30 16:19:41 UTC",
                              updated_at: "2017-11-30 16:19:41 UTC")
    end

    it "can find single invoice_item by id" do
      get "/api/v1/invoice_items/find?id=#{@invoice_item.id}"

      invoice_item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(invoice_item_response["id"]).to eq(@invoice_item.id)
    end

    it "can find single invoice_item by quantity" do
      get "/api/v1/invoice_items/find?quantity=#{@invoice_item.quantity}"

      invoice_item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(invoice_item_response["quantity"]).to eq(@invoice_item.quantity)
      expect(invoice_item_response["unit_price"]).to eq(@invoice_item.unit_price)
    end

    it "can find single invoice_item by unit_price" do
      get "/api/v1/invoice_items/find?unit_price=#{@invoice_item.unit_price}"

      invoice_item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(invoice_item_response["quantity"]).to eq(@invoice_item.quantity)
      expect(invoice_item_response["unit_price"]).to eq(@invoice_item.unit_price)
    end

    it "can find single invoice item by item_id" do
      get "/api/v1/invoice_items/find?item_id=#{@item.id}"

      invoice_item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(invoice_item_response["item_id"]).to eq(@item.id)
    end

    it "can find single invoice item by invoice_id" do
      get "/api/v1/invoice_items/find?invoice_id=#{@invoice.id}"

      invoice_item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(invoice_item_response["invoice_id"]).to eq(@invoice.id)
    end

    it "can find single invoice item by created_at" do
      get "/api/v1/invoice_items/find?created_at=#{@invoice_item.created_at}"

      invoice_item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(invoice_item_response["id"]).to eq(@invoice_item.id)
      expect(invoice_item_response["quantity"]).to eq(@invoice_item.quantity)
      expect(invoice_item_response["unit_price"]).to eq(@invoice_item.unit_price)
    end

    it "can find single invoice item by updated_at" do
      get "/api/v1/invoice_items/find?updated_at=#{@invoice_item.updated_at}"

      invoice_item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(invoice_item_response["id"]).to eq(@invoice_item.id)
      expect(invoice_item_response["quantity"]).to eq(@invoice_item.quantity)
      expect(invoice_item_response["unit_price"]).to eq(@invoice_item.unit_price)
    end

    it "can find_all invoice items by id" do
      get "/api/v1/invoice_items/find_all?id=#{@invoice_item2.id}"

      invoice_item_response = JSON.parse(response.body)
      invoice_item = invoice_item_response.first

      expect(response).to be_success
      expect(invoice_item["id"]).to eq (2)
      expect(invoice_item["quantity"]).to eq(@invoice_item2.quantity)
      expect(invoice_item["unit_price"]).to eq(@invoice_item2.unit_price)
      expect(invoice_item["item_id"]).to eq(@item.id)
      expect(invoice_item["invoice_id"]).to eq(@invoice.id)
    end

    it "can find_all invoice items by quantity" do
      get "/api/v1/invoice_items/find_all?quantity=#{@invoice_item3.quantity}"

      invoice_item_response = JSON.parse(response.body)
      invoice_item = invoice_item_response.last

      expect(response).to be_success
      expect(invoice_item_response.count).to eq(2)
      expect(invoice_item["id"]).to eq (3)
      expect(invoice_item["quantity"]).to eq(@invoice_item3.quantity)
      expect(invoice_item["unit_price"]).to eq(@invoice_item3.unit_price)
      expect(invoice_item["item_id"]).to eq(@item.id)
      expect(invoice_item["invoice_id"]).to eq(@invoice.id)
    end

    it "can find_all invoice items by unit_price" do
      get "/api/v1/invoice_items/find_all?unit_price=#{@invoice_item3.unit_price}"

      invoice_item_response = JSON.parse(response.body)
      invoice_item = invoice_item_response.first

      expect(response).to be_success
      expect(invoice_item_response.count).to eq(2)
      expect(invoice_item["id"]).to eq (1)
      expect(invoice_item["quantity"]).to eq(@invoice_item3.quantity)
      expect(invoice_item["unit_price"]).to eq(@invoice_item.unit_price)
      expect(invoice_item["item_id"]).to eq(@item.id)
      expect(invoice_item["invoice_id"]).to eq(@invoice.id)
    end

    it "can find_all invoice items by item_id" do
      get "/api/v1/invoice_items/find_all?item_id=#{@item.id}"

      invoice_item_response = JSON.parse(response.body)
      invoice_item = invoice_item_response.first

      expect(response).to be_success
      expect(invoice_item_response.count).to eq(3)
      expect(invoice_item["id"]).to eq (1)
      expect(invoice_item["quantity"]).to eq(@invoice_item.quantity)
      expect(invoice_item["unit_price"]).to eq(@invoice_item.unit_price)
      expect(invoice_item["item_id"]).to eq(@item.id)
      expect(invoice_item["invoice_id"]).to eq(@invoice.id)
    end

    it "can find_all invoice items by invoice_id" do
      get "/api/v1/invoice_items/find_all?invoice_id=#{@invoice.id}"

      invoice_item_response = JSON.parse(response.body)
      invoice_item = invoice_item_response.first

      expect(response).to be_success
      expect(invoice_item_response.count).to eq(3)
      expect(invoice_item["id"]).to eq (1)
      expect(invoice_item["quantity"]).to eq(@invoice_item.quantity)
      expect(invoice_item["unit_price"]).to eq(@invoice_item.unit_price)
      expect(invoice_item["item_id"]).to eq(@item.id)
      expect(invoice_item["invoice_id"]).to eq(@invoice.id)
    end

    it "can find_all invoice items by created_at" do
      get "/api/v1/invoice_items/find_all?created_at=#{@invoice_item.created_at}"

      invoice_item_response = JSON.parse(response.body)
      invoice_item = invoice_item_response.first

      expect(response).to be_success
      expect(invoice_item_response.count).to eq(3)
      expect(invoice_item["id"]).to eq (1)
      expect(invoice_item["quantity"]).to eq(@invoice_item.quantity)
      expect(invoice_item["unit_price"]).to eq(@invoice_item.unit_price)
      expect(invoice_item["item_id"]).to eq(@item.id)
      expect(invoice_item["invoice_id"]).to eq(@invoice.id)
    end

    it "can find_all invoice items by updated_at" do
      get "/api/v1/invoice_items/find_all?updated_at=#{@invoice_item2.updated_at}"

      invoice_item_response = JSON.parse(response.body)
      invoice_item = invoice_item_response.first

      expect(response).to be_success
      expect(invoice_item_response.count).to eq(3)
      expect(invoice_item["id"]).to eq (1)
      expect(invoice_item["quantity"]).to eq(@invoice_item.quantity)
      expect(invoice_item["unit_price"]).to eq(@invoice_item.unit_price)
      expect(invoice_item["item_id"]).to eq(@item.id)
      expect(invoice_item["invoice_id"]).to eq(@invoice.id)
    end

    it "can find a random invoice item" do
      get "/api/v1/invoice_items/random"

      invoice_item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(invoice_item_response).to have_key("id")
      expect(invoice_item_response).to have_key("quantity")
      expect(invoice_item_response).to have_key("unit_price")
      expect(invoice_item_response).to have_key("item_id")
      expect(invoice_item_response).to have_key("invoice_id")
    end
  end
end
