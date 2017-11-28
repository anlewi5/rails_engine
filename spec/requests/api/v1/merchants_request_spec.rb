require 'rails_helper'

describe "Merchants API" do
  it "lists all merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    merchants = JSON.parse(response.body)
    merchant = merchant.first

    expect(response).to be_success
    expect(merchants.count).to eq(3)
    expect(merchant).to have(:id)
    expect(merchant).to have(:name)
    expect(merchant).to have(:updated_at)
    expect(merchant).to have(:created_at)
  end
end
