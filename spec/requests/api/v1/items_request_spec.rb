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
    # expect(invoice).not_to have_key("created_at")
    # expect(invoice).not_to have_key("updated_at")
  end
end
