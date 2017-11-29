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

  it "can find a single merchant based on id" do
    merchant = create(:merchant)

    get "/api/v1/merchants/find?id=#{merchant.id}"

    merchant_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(merchant_response["id"]).to eq(merchant.id)
    expect(merchant_response["name"]).to eq(merchant.name)
    expect(merchant_response["created_at"]).to eq(merchant.created_at.to_json.delete('\\"'))
    expect(merchant_response["updated_at"]).to eq(merchant.updated_at.to_json.delete('\\"'))
  end

  it "can find a single merchant based on name" do
    merchant = create(:merchant)

    get "/api/v1/merchants/find?name=#{merchant.name}"

    merchant_response = JSON.parse(response.body)
    binding.pry
    expect(response).to be_success
    expect(merchant_response["id"]).to eq(merchant.id)
    expect(merchant_response["name"]).to eq(merchant.name)
    expect(merchant_response["created_at"]).to eq(merchant.created_at.to_json.delete('\\"'))
    expect(merchant_response["updated_at"]).to eq(merchant.updated_at.to_json.delete('\\"'))
  end

  it "can find a single merchant based on created_at" do
    merchant = create(:merchant)

    get "/api/v1/merchants/find?created_at=#{merchant.created_at}"

    merchant_response = JSON.parse(response.body)
    binding.pry
    expect(response).to be_success
    expect(merchant_response["id"]).to eq(merchant.id)
    expect(merchant_response["name"]).to eq(merchant.name)
    expect(merchant_response["created_at"]).to eq(merchant.created_at.to_json.delete('\\"'))
    expect(merchant_response["updated_at"]).to eq(merchant.updated_at.to_json.delete('\\"'))
  end

  it "can find a single merchant based on updated_at" do
    merchant = create(:merchant)

    get "/api/v1/merchants/find?updated_at=#{merchant.updated_at}"

    merchant_response = JSON.parse(response.body)

    expect(response).to be_success
    expect(merchant_response["id"]).to eq(merchant.id)
    expect(merchant_response["name"]).to eq(merchant.name)
    expect(merchant_response["created_at"]).to eq(merchant.created_at.to_json.delete('\\"'))
    expect(merchant_response["updated_at"]).to eq(merchant.updated_at.to_json.delete('\\"'))
  end
end
