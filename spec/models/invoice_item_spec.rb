require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to(:invoice) }
    it { should respond_to(:invoice) }
    it { should belong_to(:item) }
    it { should respond_to(:item) }
  end
end
