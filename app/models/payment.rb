class Payment < ApplicationRecord

  FEE = {
    AMEX: 0.05,
    MASTER: 0.035,
    VISA: 0.036
  }

  def calculate_amount_with_tax(payment)
    brand             = payment&.brand.upcase.to_sym
    tax_for_brand     = FEE.fetch(brand, 1.00) # *1.00 if payment brand != as expected
    calculate_tax     = (payment&.amount * tax_for_brand).round(2)
    original_amount   = payment&.amount
    amount_with_tax   = (original_amount - calculate_tax).round(2)
    return amount_with_tax
  end
  
  def calculate_credited_on(payment)
    payed_at    = payment.payed_at
    kind        = payment.kind
    credited_on = nil
    if kind == "credit"
      credited_on = payed_at+30.days
    else
      credited_on = payed_at+1.days
    end
    return credited_on
  end

  def att_credited_on(payment)
    payed_at    = payment.payed_at
    kind        = payment.kind
    !payment.credited_on?
    (kind == "credit")? payment.update_attribute(:credited_on,(payed_at+30.days)) : payment.update_attribute(:credited_on,(payed_at+1.days)) 
  end

  def info_payment(payment)
    #puts "ID_PAGAMENTO;VALOR_BRUTO;DATA_PAGAMENTO;TIPO;VALOR_LIQUIDO;DATA_RECEBIMENTO"
    puts "#{payment&.id};#{payment&.amount.to_f};#{payment&.payed_at.strftime("%d/%m/%Y")};#{payment.kind};#{calculate_amount_with_tax(payment)};#{calculate_credited_on(payment).strftime("%d/%m/%Y")}"
  end

end


