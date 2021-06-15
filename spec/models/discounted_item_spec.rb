require 'rails_helper'

RSpec.describe DiscountedItem do

  describe 'relationships' do
    it {should belong_to :bulk_discount }
    it {should belong_to :invoice_item }
  end

end

  describe 'validations' do
    subject { DiscountedItem.new(invoice_item_id: 10) }
    it {should validate_uniqueness_of(:id) }
  end