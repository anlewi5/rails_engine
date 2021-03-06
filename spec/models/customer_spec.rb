require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'relationships' do
    it { should have_many(:invoices) }
    it { should respond_to(:invoices) }
    it { should have_many(:merchants) }
    it { should respond_to(:merchants) }
  end
end
