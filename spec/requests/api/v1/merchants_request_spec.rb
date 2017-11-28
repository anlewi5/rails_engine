require 'rails_helper'

describe "Merchants API" do
  it "can list all merchants" do
    create_list(:merchant, 3)

    get "/api/v1/merchants"

    merchants = JSON.parse(response.body)
    merchant = merchants.first

    expect(response).to be_success
    expect(merchants.count).to eq(3)
    expect(merchant).to have_key("id")
    expect(merchant).to have_key("name")
    expect(merchant).to have_key("updated_at")
    expect(merchant).to have_key("created_at")
  end

  it "can get single merchant by id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_success
    expect(merchant["id"]).to eq(id)
  end

  it "can find a single merchant based on attributes" do
    merchant = create(:merchant)

    get "/api/v1/merchants/find?id=#{merchant.id}"
    binding.pry

    get "/api/v1/merchants/find?name=#{merchant.name}"

    get "/api/v1/merchants/find?created_at=#{merchant.created_at}"

    get "/api/v1/merchants/find?updated_at=#{merchant.updated_at}"
  end
end
