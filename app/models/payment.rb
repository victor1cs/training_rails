class Payment < ApplicationRecord

  FEE = {
    AMEX:   0.05,
    MASTER: 0.035,
    VISA:   0.036
  }.freeze

  CALCULATE = {
    credit: 30,
    debit:  1,
    pix:    0,
    money:  0
  }.freeze

  def calculate_amount_with_tax
    brand             = self.brand.upcase.to_sym
    tax_for_brand     = FEE.fetch(brand, 1.00) # *1.00 if payment brand != as expected
    calculate_tax     = (self.amount * tax_for_brand).round(2)
    original_amount   = self.amount
    amount_with_tax   = (original_amount - calculate_tax).round(2)
    return amount_with_tax
  end
  
  def calculate_credited_on
    payed_at              = self.payed_at
    kind                  = self.kind
    calculate_credited_on = CALCULATE[kind.to_sym]&.days || 1
    credited_on           = payed_at + calculate_credited_on
    return credited_on
  end

  def att_credited_on!
    payed_at    = self.payed_at
    kind        = self.kind
    calculate   = CALCULATE[kind.to_sym]&.days
    return if self.credited_on.present?
    self.update!(credited_on: payed_at+calculate) unless calculate.nil?
  end

  # def info_payment
  #   puts "ID_PAGAMENTO;VALOR_BRUTO;DATA_PAGAMENTO;TIPO;VALOR_LIQUIDO;DATA_RECEBIMENTO"
  #   puts "#{self&.id};#{self&.amount.to_f};#{self&.payed_at.strftime("%d/%m/%Y")};#{self.kind};#{calculate_amount_with_tax(self)};#{calculate_credited_on(payment).strftime("%d/%m/%Y")}"
  # end

end


