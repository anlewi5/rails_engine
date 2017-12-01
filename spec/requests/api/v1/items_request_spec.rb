require 'rails_helper'

describe "Items API" do
  describe "Record Endpoints" do
    it "can list all items" do
      merchant = create(:merchant)
      create_list(:item, 4, merchant_id: merchant.id)

      get "/api/v1/items"

      items = JSON.parse(response.body)
      item = items.first

      expect(response).to be_success
      expect(items.count).to eq 4
      expect(item).to have_key("id")
      expect(item).to have_key("name")
      expect(item).to have_key("description")
      expect(item).to have_key("unit_price")
      expect(item).to have_key("merchant_id")
      expect(item).not_to have_key("created_at")
      expect(item).not_to have_key("updated_at")
    end

    it "can list all items" do
      merchant = create(:merchant)
      items = create_list(:item, 4, merchant_id: merchant.id)

      get "/api/v1/items/#{items.first.id}"

      items_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(items_response["id"]).to eq 1
      expect(items_response).to have_key("id")
      expect(items_response).to have_key("name")
      expect(items_response).to have_key("description")
      expect(items_response).to have_key("unit_price")
      expect(items_response).to have_key("merchant_id")
      expect(items_response).not_to have_key("created_at")
      expect(items_response).not_to have_key("updated_at")
    end
  end

  describe "Item find, find all, and random" do
    let(:merchant) {create(:merchant)}
    let!(:item)     {create(:item,
                            name: "Camera",
                            unit_price: 300,
                            merchant: merchant,
                            created_at: "2012-03-27T14:54:05.000Z",
                            updated_at: "2012-03-27T14:54:05.000Z")}
    let!(:item2)    {create(:item,
                            name: "Camera",
                            unit_price: 300,
                            merchant: merchant,
                            created_at: "2012-03-27T14:54:05.000Z",
                            updated_at: "2012-03-27T14:54:05.000Z")}
    let!(:item3)    {create(:item)}

    it "can find single item by id" do
      get "/api/v1/items/find?id=#{item.id}"

      item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(item_response["id"]).to eq(item.id)
    end

    it "can find single item by name" do
      get "/api/v1/items/find?name=#{item.name}"

      item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(item_response["name"]).to eq(item.name)
      expect(item_response["description"]).to eq(item.description)
      expect(item_response["unit_price"]).to eq("3.0")
    end

    it "can find single item by description" do
      get "/api/v1/items/find?description=#{item.description}"

      item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(item_response["name"]).to eq(item.name)
      expect(item_response["description"]).to eq(item.description)
      expect(item_response["unit_price"]).to eq("3.0")
    end

    it "can find single item by unit_price" do
      get "/api/v1/items/find?unit_price=3.0"

      item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(item_response["name"]).to eq(item.name)
      expect(item_response["description"]).to eq(item.description)
      expect(item_response["unit_price"]).to eq("3.0")
    end

    it "can find single item by merchant_id" do
      get "/api/v1/items/find?merchant_id=#{merchant.id}"

      item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(item_response["name"]).to eq(item.name)
      expect(item_response["description"]).to eq(item.description)
      expect(item_response["unit_price"]).to eq("3.0")
    end

    it "can find single item by created_at" do
      get "/api/v1/items/find?created_at=2012-03-27T14:54:05.000Z"

      item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(item_response["name"]).to eq(item.name)
      expect(item_response["description"]).to eq(item.description)
      expect(item_response["unit_price"]).to eq("3.0")
    end

    it "can find single item by updated_at" do
      get "/api/v1/items/find?updated_at=2012-03-27T14:54:05.000Z"

      item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(item_response["name"]).to eq(item.name)
      expect(item_response["description"]).to eq(item.description)
      expect(item_response["unit_price"]).to eq("3.0")
    end

    it "can find all items by id" do
      get "/api/v1/items/find_all?id=#{item.id}"

      item_response = JSON.parse(response.body)
      single_item = item_response.first

      expect(response).to be_success
      expect(item_response.count).to eq (1)
      expect(single_item["id"]).to eq (1)
      expect(single_item["name"]).to eq(item.name)
      expect(single_item["description"]).to eq(item.description)
      expect(single_item["unit_price"]).to eq("3.0")
    end

    it "can find all items by name" do
      get "/api/v1/items/find_all?name=#{item.name}"

      item_response = JSON.parse(response.body)
      single_item = item_response.first

      expect(response).to be_success
      expect(item_response.count).to eq (2)
      expect(single_item["id"]).to eq (1)
      expect(single_item["name"]).to eq(item.name)
      expect(single_item["description"]).to eq(item.description)
      expect(single_item["unit_price"]).to eq("3.0")
    end

    it "can find all items by description" do
      get "/api/v1/items/find_all?description=#{item.description}"

      item_response = JSON.parse(response.body)
      single_item = item_response.first

      expect(response).to be_success
      expect(item_response.count).to eq (1)
      expect(single_item["id"]).to eq (1)
      expect(single_item["name"]).to eq(item.name)
      expect(single_item["description"]).to eq(item.description)
      expect(single_item["unit_price"]).to eq("3.0")
    end

    it "can find all items by unit_price" do
      get "/api/v1/items/find_all?unit_price=3.0"

      item_response = JSON.parse(response.body)
      single_item = item_response.first

      expect(response).to be_success
      expect(item_response.count).to eq (2)
      expect(single_item["id"]).to eq (1)
      expect(single_item["name"]).to eq(item.name)
      expect(single_item["description"]).to eq(item.description)
      expect(single_item["unit_price"]).to eq("3.0")
    end
    it "can find all items by created_at" do
      get "/api/v1/items/find_all?created_at=2012-03-27T14:54:05.000Z"

      item_response = JSON.parse(response.body)
      single_item = item_response.first

      expect(response).to be_success
      expect(item_response.count).to eq (2)
      expect(single_item["id"]).to eq (1)
      expect(single_item["name"]).to eq(item.name)
      expect(single_item["description"]).to eq(item.description)
      expect(single_item["unit_price"]).to eq("3.0")
    end

    it "can find all items by updated_at" do
      get "/api/v1/items/find_all?updated_at=2012-03-27T14:54:05.000Z"

      item_response = JSON.parse(response.body)
      single_item = item_response.first

      expect(response).to be_success
      expect(item_response.count).to eq (2)
      expect(single_item["id"]).to eq (1)
      expect(single_item["name"]).to eq(item.name)
      expect(single_item["description"]).to eq(item.description)
      expect(single_item["unit_price"]).to eq("3.0")
    end

    it "can find a random item" do
      get "/api/v1/items/random"

      invoice_item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(invoice_item_response).to have_key("id")
      expect(invoice_item_response).to have_key("name")
      expect(invoice_item_response).to have_key("description")
      expect(invoice_item_response).to have_key("unit_price")
      expect(invoice_item_response).to have_key("merchant_id")
    end
  end

  describe 'business intelligence' do
    let!(:invoice)        {create(:invoice)}
    let!(:invoice_items)  {create(:invoice_item, quantity: 3, item: item)}
    let!(:invoice_items1) {create(:invoice_item, quantity: 6, item: item)}
    let!(:invoice_items2) {create(:invoice_item, quantity: 5, item: item2)}
    let!(:invoice_items3) {create(:invoice_item, quantity: 1, item: item3)}
    let!(:transaction)    {create(:transaction)}
    let!(:item)           {create(:item,
                            name: "Camera",
                            unit_price: 140000,
                            created_at: "2012-03-27T14:54:05.000Z",
                            updated_at: "2012-03-27T14:54:05.000Z")}
    let!(:item2)          {create(:item,
                            name: "Shoes",
                            unit_price: 20000,
                            created_at: "2012-03-27T14:54:05.000Z",
                            updated_at: "2012-03-27T14:54:05.000Z")}
    let!(:item3)          {create(:item)}

    it 'can return most_items ranked by total sold quantity=1' do
      get '/api/v1/items/most_items?quantity=1'

      most_items_response = JSON.parse(response.body)
      top_item = most_items_response.first

      expect(response).to be_success
      expect(most_items_response.count).to eq(1)
      expect(top_item["name"]).to eq("Camera")
    end

  end
end
