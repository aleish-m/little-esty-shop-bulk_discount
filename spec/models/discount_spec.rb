require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe "validations" do
    it { should validate_presence_of :discount }
    it { should validate_presence_of :threshold }
    it { should validates_numericality_of(:discount).is_less_than_or_equal_to(1) }
    it { should validates_numericality_of :threshold }
  end
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end
end