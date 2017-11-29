require 'rails_helper'

describe "Items API" do
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
