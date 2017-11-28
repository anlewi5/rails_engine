require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should respond_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should respond_to(:invoice_items) }
    it { should have_many(:invoices) }
    it { should respond_to(:invoices) }
  end
end
