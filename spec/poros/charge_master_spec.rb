require 'rails_helper'

RSpec.describe ChargeMaster do

  before :each do
    BulkDiscount.destroy_all
    # YO These values depend on full data set and need to be reworked
    @merchant = Merchant.find(7)
    @invoice = Invoice.find(29)
    @bulk_discount_1 = @merchant.bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 0.15)
    @bulk_discount_2 = @merchant.bulk_discounts.create!(quantity_threshold: 8, percentage_discount: 0.20)
    @bulk_discount_3 = @merchant.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 0.25)
  end

  describe '::initialize_discounts' do
    it 'is able to create new discounted items' do
      ChargeMaster.initialize_discounts(@invoice.id, @merchant.bulk_discounts)
      expect(DiscountedItem.all.empty?).to eq true
      correct_placement_1 = DiscountedItem.where("discounted_items.percentage_discount = 0.15")
      correct_placement_2 = DiscountedItem.where("discounted_items.percentage_discount = 0.20")
      correct_placement_3 = DiscountedItem.where("discounted_items.percentage_discount = 0.25")
      ##### YO I need to add a quantity column in DiscountedItem
      #case_1 = correct_placement_1.all? { |item| item.quantity >= 5 && item.quantity < 8 }
      #case_2 = correct_placement_2.all? { |item| item.quantity >= 8 && item.quantity < 10 }
      #case_3 = correct_placement_3.all? { |item| item.quantity >= 10}
        
      #expect(case_1).to eq true
      #expect(case_2).to eq true
      #expect(case_3).to eq true
    end
  end
end
