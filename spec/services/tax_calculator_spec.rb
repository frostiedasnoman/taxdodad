require "rails_helper"

RSpec.describe TaxCalculator do
  subject(:calc) { TaxCalculator.new(taxable_amount).perform}
  let(:taxable_amount) { "10000.00" }

  context "with a taxable amount of $10,000.00" do
    it "returns a total tax to pay of $1,050.00" do
      expect(calc).to eq(BigDecimal("1050"))
    end
  end

  context "with a taxable amount of $35,000.00" do
    let(:taxable_amount) { "35000.00" }
    it "returns a total tax to pay of $5,033.00" do
      expect(calc).to eq(BigDecimal("5033"))
    end
  end

  context "with a taxable amount of $100,000.00" do
    let(:taxable_amount) { "100000.00" }
    it "returns a total tax to pay of $22,877.50" do
      expect(calc).to eq(BigDecimal("22877.50"))
    end
  end

  context "with a taxable amount of $200,000.00" do
    let(:taxable_amount) { "200000.00" }
    it "returns a total tax to pay of $64,877.50" do
      expect(calc).to eq(BigDecimal("64877.50"))
    end
  end
end