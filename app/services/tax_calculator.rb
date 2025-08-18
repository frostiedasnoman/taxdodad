class TaxCalculator
  # only console service so don't need a UseCase

  def initialize(amount)
    @taxable_amount = BigDecimal(amount).round
    @total_tax_to_pay = BigDecimal("0")
    @taxable_amount_remaining = @taxable_amount
  end

  def perform
    tax_bands.each do |band|
      taxable_amount_in_band = [@taxable_amount_remaining, band.amount_in_band].min
      tax_to_pay_in_band = (taxable_amount_in_band * band.tax_rate_multiplier).round(2)
      @total_tax_to_pay += tax_to_pay_in_band
      @taxable_amount_remaining -= taxable_amount_in_band
      break if @taxable_amount_remaining == 0
    end
    @total_tax_to_pay
  end

  private

  def tax_bands
    @tax_bands ||= init_tax_bands
  end

  def init_tax_bands
    bands = []
    bands << TaxBand.new(BigDecimal("0"), BigDecimal("15600"), BigDecimal("10.5"))
    bands << TaxBand.new(BigDecimal("15601"), BigDecimal("53500"), BigDecimal("17.5"))
    bands << TaxBand.new(BigDecimal("53501"), BigDecimal("78100"), BigDecimal("30"))
    bands << TaxBand.new(BigDecimal("78101"), BigDecimal("180000"), BigDecimal("33"))
    bands << TaxBand.new(BigDecimal("180101"), BigDecimal("Infinity"), BigDecimal("39"))
  end

  # Maybe should be a model?
  TaxBand = Struct.new(:min_amount, :max_amount, :tax_rate) do
    def amount_in_band
      return max_amount if max_amount == BigDecimal("Infinity")

      max_amount - min_amount
    end

    def tax_rate_multiplier
      tax_rate/100
    end
  end
end